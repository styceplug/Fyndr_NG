import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fyndr_ng/widgets/custom_appbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';


class FaceVerificationScreen extends StatelessWidget {
  final VoidCallback onVerificationSuccess;

  const FaceVerificationScreen({Key? key, required this.onVerificationSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(
        leadingIcon: BackButton(color: Colors.black),
        title: "Please Verify Your Identity",
      ),
      body: FaceLivenessCam(
        onSuccess: onVerificationSuccess,
      ),
    );
  }
}

// --- 2. THE REAL ML WIDGET ---
class FaceLivenessCam extends StatefulWidget {
  final VoidCallback onSuccess;

  const FaceLivenessCam({Key? key, required this.onSuccess}) : super(key: key);

  @override
  State<FaceLivenessCam> createState() => _FaceLivenessCamState();
}

class _FaceLivenessCamState extends State<FaceLivenessCam> {
  CameraController? _controller;
  FaceDetector? _faceDetector;
  bool _isCameraInitialized = false;
  bool _isBusy = false; // Prevents processing multiple frames at once
  String _instructionText = "Initializing...";

  // Liveness Logic State
  bool _faceDetected = false;
  bool _isBlinking = false; // Has the user closed their eyes?
  int _consecutiveFrames = 0; // Debounce logic

  @override
  void initState() {
    super.initState();
    _initializeCameraAndDetector();
  }

  Future<void> _initializeCameraAndDetector() async {
    // 1. Initialize ML Kit Face Detector
    final options = FaceDetectorOptions(
      enableClassification: true, // Needed for Eyes/Smile
      enableLandmarks: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    );
    _faceDetector = FaceDetector(options: options);

    // 2. Permission Check
    var status = await Permission.camera.request();
    if (status.isDenied) return;

    // 3. Initialize Camera
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium, // Medium is usually sufficient for ML
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller!.initialize();

    if (!mounted) return;

    // 4. Start Image Stream for Real-time Processing
    _controller!.startImageStream(_processCameraImage);

    setState(() {
      _isCameraInitialized = true;
      _instructionText = "Position your face in the oval";
    });
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isBusy || _faceDetector == null) return;
    _isBusy = true;

    try {
      // Convert CameraImage to ML Kit InputImage
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      // Detect Faces
      final faces = await _faceDetector!.processImage(inputImage);

      _handleFaceLogic(faces);

    } catch (e) {
      print("Error processing face: $e");
    } finally {
      _isBusy = false;
    }
  }

  void _handleFaceLogic(List<Face> faces) {
    if (faces.isEmpty) {
      // Reset state if face is lost
      if (mounted) setState(() {
        _faceDetected = false;
        _isBlinking = false;
        _instructionText = "Position your face in the oval";
      });
      return;
    }

    // We assume the primary face is the first one
    final face = faces.first;



    if (!_faceDetected) {
      if (mounted) setState(() {
        _faceDetected = true;
        _instructionText = "Please Blink to verify";
      });
    }


    double leftEyeOpen = face.leftEyeOpenProbability ?? 1.0;
    double rightEyeOpen = face.rightEyeOpenProbability ?? 1.0;

    const double openThreshold = 0.85;
    const double closedThreshold = 0.15;



    if (!_isBlinking) {
      if (leftEyeOpen < closedThreshold && rightEyeOpen < closedThreshold) {
        _isBlinking = true;
        if (mounted) setState(() => _instructionText = "Keep blinking...");
      }
    } else {
      if (leftEyeOpen > openThreshold && rightEyeOpen > openThreshold) {
        _finishVerification();
      }
    }
  }

  void _finishVerification() async {
    // Stop processing
    await _controller?.stopImageStream();
    _faceDetector?.close();

    if (mounted) {
      setState(() => _instructionText = "Verified!");
      // Trigger success callback
      widget.onSuccess();
    }
  }

  // --- HELPER: Convert CameraImage to InputImage ---
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _controller!.description;
    final sensorOrientation = camera.sensorOrientation;

    // Logic to handle rotation (critical for ML Kit)
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };

    // Note: You might need to check SystemChrome.preferredOrientations
    // For now assuming Portrait Up
    final rotationCompensation = (sensorOrientation + orientations[DeviceOrientation.portraitUp]! + 360) % 360;

    InputImageRotation? rotation;
    if (rotationCompensation == 0) rotation = InputImageRotation.rotation0deg;
    else if (rotationCompensation == 90) rotation = InputImageRotation.rotation90deg;
    else if (rotationCompensation == 180) rotation = InputImageRotation.rotation180deg;
    else if (rotationCompensation == 270) rotation = InputImageRotation.rotation270deg;

    if (rotation == null) return null;

    // Handle Format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // Since we are concatenating planes, this mostly applies to Android (NV21)
    // iOS (BGRA8888) usually has one plane
    if (image.planes.isEmpty) return null;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: Uint8List.fromList(
        image.planes.fold<List<int>>([], (previousValue, element) => previousValue..addAll(element.bytes)),
      ),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraInitialized || _controller == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_controller!),

        CustomPaint(
          painter: FaceOverlayPainter(),
          child: Container(),
        ),

        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Text(
                _instructionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- 3. PAINTER (Same as before) ---
class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final center = Offset(size.width / 2, size.height / 2.5);
    final radiusX = size.width * 0.35;
    final radiusY = size.height * 0.25;

    final holePath = Path()
      ..addOval(Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2));
    final screenPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final overlayPath = Path.combine(PathOperation.difference, screenPath, holePath);
    canvas.drawPath(overlayPath, paint);

    final borderPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawOval(
        Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2),
        borderPaint
    );
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}