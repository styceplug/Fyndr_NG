import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MediaAttachmentWidget extends StatefulWidget {
  final Function(File?)? onImageSelected;
  final String? title;

  const MediaAttachmentWidget({super.key, this.onImageSelected, this.title});

  @override
  State<MediaAttachmentWidget> createState() => _MediaAttachmentWidgetState();
}

class _MediaAttachmentWidgetState extends State<MediaAttachmentWidget> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedFile;
  double _uploadProgress = 0.0;
  File? _compressedImage;

  Future<void> _pickMedia(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        final compressed = await _compressImage(File(file.path));
        setState(() {
          _selectedFile = file;
          _compressedImage = compressed;
        });

        _simulateUpload();
        widget.onImageSelected?.call(compressed);
      }
    } catch (e) {
      print("❌ Error picking image: $e");
    }
  }

  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.path,
      'compressed_${path.basename(file.path)}',
    );

    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 25,
      minWidth: 600,
      minHeight: 600,
    );

    return compressed != null ? File(compressed.path) : null;
  }

  void _simulateUpload() {
    const duration = Duration(milliseconds: 150);
    double progress = 0.0;

    Timer.periodic(duration, (timer) {
      if (progress >= 1.0) {
        timer.cancel();
        setState(() {
          _uploadProgress = 1.0;
        });
      } else {
        progress += 0.1;
        setState(() {
          _uploadProgress = progress;
        });
      }
    });
  }

  void _clearImage() {
    setState(() {
      _selectedFile = null;
      _compressedImage = null;
      _uploadProgress = 0.0;
    });
    widget.onImageSelected?.call(null);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title ?? "Media Attachment",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () => _pickMedia(ImageSource.gallery),
              icon: Icon(Icons.photo_library, color: theme.iconTheme.color),
              label: Text(
                "Gallery",
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.dividerColor),
              ),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () => _pickMedia(ImageSource.camera),
              icon: Icon(Icons.camera_alt, color: theme.iconTheme.color),
              label: Text(
                "Camera",
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.dividerColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        if (_compressedImage != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _compressedImage!,
                  height: 140,
                  width: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.black.withOpacity(0.35),
                      alignment: Alignment.center,
                      child: IconButton(
                        onPressed: _clearImage,
                        icon: const Icon(
                          Icons.delete_forever,
                          size: 32,
                          color: Colors.white,
                        ),
                        tooltip: 'Remove Image',
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                left: 6,
                right: 6,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _uploadProgress,
                    minHeight: 5,
                    backgroundColor: theme.dividerColor.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _uploadProgress >= 1.0
                          ? Colors.green
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
