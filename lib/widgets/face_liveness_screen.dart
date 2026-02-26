import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import 'custom_appbar.dart';

class FaceVerificationScreen extends StatelessWidget {
  final VoidCallback onVerificationSuccess;

  const FaceVerificationScreen({
    super.key,
    required this.onVerificationSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      appBar: CustomAppbar(
        leadingIcon: const BackButton(color: Colors.white),
        title: "Verify your identity",
      ),
      body: FaceLivenessCam(
        onSuccess: onVerificationSuccess,
      ),
    );
  }
}


enum LivenessStep {
  positionFace,
  turnLeft,
  turnRight,
  blink,
  openMouth,
  holdStill,
  verified,
  failed,
}

class FaceLivenessCam extends StatefulWidget {
  final VoidCallback onSuccess;

  const FaceLivenessCam({super.key, required this.onSuccess});

  @override
  State<FaceLivenessCam> createState() => _FaceLivenessCamState();
}

class _FaceLivenessCamState extends State<FaceLivenessCam>
    with WidgetsBindingObserver {
  CameraController? _controller;
  FaceDetector? _detector;

  bool _cameraReady = false;
  bool _processing = false;
  bool _streaming = false;

  String _titleText = "Initializing…";
  String _hintText = "Please wait";

  // ---- Bank-grade-ish logic ----
  final List<LivenessStep> _sequence = [];
  LivenessStep _step = LivenessStep.positionFace;

  DateTime? _stepStartedAt;
  int _goodFrames = 0;

  // Debounce thresholds
  static const int requiredGoodFrames = 6; // stable confirmation

  // anti-spoof heuristics
  double _lastYaw = 0;
  double _lastPitch = 0;
  double _lastRoll = 0;

  int _faceLostFrames = 0;

  // Blink tracking
  bool _eyesWereClosed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Build a randomized but consistent sequence
    // FaceID-ish: head turn left/right + blink + mouth open + hold
    _sequence
      ..clear()
      ..addAll([
        LivenessStep.positionFace,
        ..._randomTurns(), // left/right order randomized
        LivenessStep.blink,
        LivenessStep.openMouth,
        LivenessStep.holdStill,
      ]);

    _step = _sequence.first;
    _initialize();
  }

  List<LivenessStep> _randomTurns() {
    final turns = [LivenessStep.turnLeft, LivenessStep.turnRight];
    turns.shuffle(math.Random());
    return turns;
  }

  Future<void> _initialize() async {
    setState(() {
      _titleText = "Preparing camera…";
      _hintText = "Grant camera access";
    });

    // 1) Permission
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      setState(() {
        _titleText = "Camera permission needed";
        _hintText = "Enable Camera permission in Settings";
        _step = LivenessStep.failed;
      });
      return;
    }

    // 2) MLKit detector
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true, // eye probs
        enableLandmarks: true,      // mouth landmarks
        enableTracking: true,
        performanceMode: FaceDetectorMode.accurate, // iOS stability
        minFaceSize: 0.15,          // ignore tiny far faces
      ),
    );

    // 3) Camera
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller!.initialize();
    if (!mounted) return;

    setState(() {
      _cameraReady = true;
      _titleText = "Center your face";
      _hintText = "Align your face inside the oval";
    });

    _startStreamSafely();
  }

  Future<void> _startStreamSafely() async {
    if (_controller == null) return;
    if (_streaming) return;
    if (!_controller!.value.isInitialized) return;

    try {
      await _controller!.startImageStream(_onFrame);
      _streaming = true;
    } catch (e) {
      // If already streaming, ignore safely
      debugPrint("⚠️ startImageStream error: $e");
    }
  }

  Future<void> _stopStreamSafely() async {
    if (_controller == null) return;
    if (!_streaming) return;

    try {
      await _controller!.stopImageStream();
    } catch (e) {
      debugPrint("⚠️ stopImageStream error: $e");
    } finally {
      _streaming = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    // This prevents your crash:
    // startImageStream called while already streaming + disposed controller usage
    final ctrl = _controller;
    if (ctrl == null) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      await _stopStreamSafely();
    } else if (state == AppLifecycleState.resumed) {
      if (mounted && _cameraReady) {
        await _startStreamSafely();
      }
    }
  }

  Future<void> _onFrame(CameraImage image) async {
    if (_processing) return;
    if (_detector == null) return;
    if (!mounted) return;

    _processing = true;
    try {
      final input = _inputImageFromCameraImage(image);
      if (input == null) return;

      final faces = await _detector!.processImage(input);
      _handleFaces(faces, input.metadata?.size);
    } catch (e) {
      debugPrint("❌ Frame processing error: $e");
    } finally {
      _processing = false;
    }
  }

  void _handleFaces(List<Face> faces, Size? imageSize) {
    if (faces.isEmpty) {
      _faceLostFrames++;
      if (_faceLostFrames > 10) {
        _goodFrames = 0;
        _eyesWereClosed = false;
        setState(() {
          _titleText = "Face not detected";
          _hintText = "Move into the oval with good lighting";
        });
      }
      return;
    }

    _faceLostFrames = 0;
    final face = faces.first;

    // --------- Anti-spoof / quality gates ----------
    // 1) Face too small (far away)
    if (face.boundingBox.width < 120 || face.boundingBox.height < 120) {
      _resetGoodFrames();
      setState(() {
        _titleText = "Move closer";
        _hintText = "Your face is too far";
      });
      return;
    }

    // 2) Strong roll/pitch out of range (phone tilted)
    final yaw = face.headEulerAngleY ?? 0;  // left/right
    final pitch = face.headEulerAngleX ?? 0; // up/down
    final roll = face.headEulerAngleZ ?? 0;  // tilt

    if (pitch.abs() > 20) {
      _resetGoodFrames();
      setState(() {
        _titleText = "Hold phone steady";
        _hintText = "Keep your head level";
      });
      return;
    }

    // 3) Require some natural micro-movement over time (prevents static photo)
    // We don’t fail instantly—just use it as a “must change a bit” signal.
    final movementScore =
        (yaw - _lastYaw).abs() + (roll - _lastRoll).abs() + (pitch - _lastPitch).abs();
    _lastYaw = yaw;
    _lastPitch = pitch;
    _lastRoll = roll;

    // If user is on steps that require motion, we accept movement.
    // If they NEVER move across many frames, we’ll fail later via timeout.
    // (Handled below with timeouts.)

    // --------- Step Machine ----------
    _ensureStepTimerStarted();

    switch (_step) {
      case LivenessStep.positionFace:
      // Need stable center for a few frames
        _passIfStable(
          condition: () => _isFaceCentered(face),
          onPrompt: () {
            setState(() {
              _titleText = "Center your face";
              _hintText = "Align within the oval";
            });
          },
          onPassed: _advanceStep,
        );
        break;

      case LivenessStep.turnLeft:
        _passIfStable(
          condition: () => yaw < -18,
          onPrompt: () {
            setState(() {
              _titleText = "Turn your head left";
              _hintText = "Slowly look to your left";
            });
          },
          onPassed: _advanceStep,
        );
        break;

      case LivenessStep.turnRight:
        _passIfStable(
          condition: () => yaw > 18,
          onPrompt: () {
            setState(() {
              _titleText = "Turn your head right";
              _hintText = "Slowly look to your right";
            });
          },
          onPassed: _advanceStep,
        );
        break;

      case LivenessStep.blink:
        _passIfStable(
          condition: () => _detectBlink(face),
          onPrompt: () {
            setState(() {
              _titleText = "Blink";
              _hintText = "Close and open both eyes";
            });
          },
          onPassed: () {
            _eyesWereClosed = false;
            _advanceStep();
          },
        );
        break;

      case LivenessStep.openMouth:
        _passIfStable(
          condition: () => _isMouthOpen(face),
          onPrompt: () {
            setState(() {
              _titleText = "Open your mouth";
              _hintText = "Open slightly, then close";
            });
          },
          onPassed: _advanceStep,
        );
        break;

      case LivenessStep.holdStill:
      // Hold still for a short time while face stays centered
        final heldLongEnough = _elapsedStepMs() > 900; // ~1 sec hold
        final centered = _isFaceCentered(face);
        final veryLowMovement = movementScore < 1.4;

        if (centered && veryLowMovement) {
          if (heldLongEnough) {
            _verifySuccess();
          } else {
            setState(() {
              _titleText = "Hold still…";
              _hintText = "Almost done";
            });
          }
        } else {
          // Don’t accumulate; reset timer by restarting step start
          _stepStartedAt = DateTime.now();
          setState(() {
            _titleText = "Hold still…";
            _hintText = "Keep your face centered";
          });
        }
        break;

      case LivenessStep.verified:
      case LivenessStep.failed:
        break;
    }

    // ---------- Timeouts (bank-grade-ish) ----------
    // Each step gets a max time; if exceeded, fail.
    if (_elapsedStepMs() > 15000 && _step != LivenessStep.verified) {
      _fail("Timed out", "Try again in better lighting");
    }
  }

  bool _isFaceCentered(Face face) {
    // Simple center check – if you want, you can map to overlay oval more exactly.
    // This already feels FaceID-ish because user must align.
    final box = face.boundingBox;
    final cx = box.left + box.width / 2;
    final cy = box.top + box.height / 2;

    // These are rough “screen-space” rules (works well enough).
    // If you want perfect oval mapping, we’ll compute from preview size.
    return cx > 120 && cx < 520 && cy > 160 && cy < 520;
  }

  void _passIfStable({
    required bool Function() condition,
    required VoidCallback onPrompt,
    required VoidCallback onPassed,
  }) {
    onPrompt();

    if (condition()) {
      _goodFrames++;
      if (_goodFrames >= requiredGoodFrames) {
        _goodFrames = 0;
        onPassed();
      }
    } else {
      _resetGoodFrames();
    }
  }

  void _resetGoodFrames() {
    _goodFrames = 0;
  }

  void _ensureStepTimerStarted() {
    _stepStartedAt ??= DateTime.now();
  }

  int _elapsedStepMs() {
    final start = _stepStartedAt;
    if (start == null) return 0;
    return DateTime.now().difference(start).inMilliseconds;
  }

  void _advanceStep() {
    final idx = _sequence.indexOf(_step);
    if (idx == -1) return;

    final nextIdx = idx + 1;
    if (nextIdx >= _sequence.length) {
      _verifySuccess();
      return;
    }

    setState(() {
      _step = _sequence[nextIdx];
      _stepStartedAt = DateTime.now();
      _goodFrames = 0;
      _eyesWereClosed = false;
    });
  }

  bool _detectBlink(Face face) {
    final left = face.leftEyeOpenProbability ?? 1.0;
    final right = face.rightEyeOpenProbability ?? 1.0;

    const closed = 0.18;
    const open = 0.82;

    final bothClosed = left < closed && right < closed;
    final bothOpen = left > open && right > open;

    if (!_eyesWereClosed) {
      if (bothClosed) _eyesWereClosed = true;
      return false;
    } else {
      // blink completed: closed -> open
      return bothOpen;
    }
  }

  bool _isMouthOpen(Face face) {
    final ratio = _mouthOpenLandmarkRatio(face);
    if (ratio == null) return false;
    // Tune: 0.28~0.35 works on most faces.
    return ratio > 0.30;
  }

  double? _mouthOpenLandmarkRatio(Face face) {
    // ✅ Correct enum names (new API)
    final left = face.landmarks[FaceLandmarkType.leftMouth]?.position;
    final right = face.landmarks[FaceLandmarkType.rightMouth]?.position;
    final bottom = face.landmarks[FaceLandmarkType.bottomMouth]?.position;

    if (left == null || right == null || bottom == null) return null;

    final mouthWidth = (right.x - left.x).abs();
    if (mouthWidth <= 0) return null;

    final midY = (left.y + right.y) / 2;
    final openDistance = (bottom.y - midY).abs();

    return openDistance / mouthWidth;
  }

  Future<void> _verifySuccess() async {
    if (_step == LivenessStep.verified) return;

    setState(() {
      _step = LivenessStep.verified;
      _titleText = "Verified";
      _hintText = "Identity confirmed";
    });

    await _stopStreamSafely();
    await _detector?.close();
    _detector = null;

    if (!mounted) return;
    widget.onSuccess();
  }

  void _fail(String title, String hint) async {
    if (_step == LivenessStep.failed) return;

    setState(() {
      _step = LivenessStep.failed;
      _titleText = title;
      _hintText = hint;
    });

    await _stopStreamSafely();
  }

  // -------- InputImage conversion (kept similar, but safer) --------
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    final ctrl = _controller;
    if (ctrl == null) return null;

    final camera = ctrl.description;
    final rotation = _rotationFromSensor(camera.sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    if (image.planes.isEmpty) return null;

    // Concatenate planes (works for NV21 / BGRA8888 use-case)
    final bytes = Uint8List.fromList(
      image.planes.fold<List<int>>(
        <int>[],
            (prev, plane) => prev..addAll(plane.bytes),
      ),
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  InputImageRotation? _rotationFromSensor(int sensorOrientation) {
    // Assuming portraitUp lock
    // (If you allow rotation, we can compute from device orientation)
    final rotationCompensation = (sensorOrientation + 0 + 360) % 360;
    switch (rotationCompensation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopStreamSafely();
    _controller?.dispose();
    _detector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraReady || _controller == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(_titleText, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 6),
            Text(_hintText, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_controller!),

        // overlay
        CustomPaint(
          painter: FaceOverlayPainter(),
          child: const SizedBox.expand(),
        ),

        // text UI (FaceID-ish)
        Positioned(
          left: 24,
          right: 24,
          bottom: 90,
          child: Column(
            children: [
              Text(
                _titleText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _hintText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.55);

    final center = Offset(size.width / 2, size.height / 2.4);
    final radiusX = size.width * 0.34;
    final radiusY = size.height * 0.22;

    final hole = Path()
      ..addOval(Rect.fromCenter(
        center: center,
        width: radiusX * 2,
        height: radiusY * 2,
      ));

    final screen = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final overlay = Path.combine(PathOperation.difference, screen, hole);

    canvas.drawPath(overlay, overlayPaint);

    final border = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2),
      border,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

