import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_constants.dart';
import '../utils/dimensions.dart';

class AvatarUploadWidget extends StatefulWidget {
  final String? avatarUrl;
  final void Function(File file) onImageSelected;

  const AvatarUploadWidget({
    super.key,
    required this.avatarUrl,
    required this.onImageSelected,
  });

  @override
  State<AvatarUploadWidget> createState() => _AvatarUploadWidgetState();
}

class _AvatarUploadWidgetState extends State<AvatarUploadWidget> {
  File? selectedFile;

  final ImagePicker _picker = ImagePicker();

  void _showSourceSelector() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.of(context).pop(); // Close the bottom sheet

    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      final file = File(image.path);
      setState(() => selectedFile = file);
      widget.onImageSelected(file);
    }
  }

  ImageProvider _getImageProvider() {
    if (selectedFile != null) return FileImage(selectedFile!);
    if (widget.avatarUrl != null && widget.avatarUrl!.isNotEmpty) {
      return NetworkImage(widget.avatarUrl!);
    }
    return AssetImage(AppConstants.getPngAsset('avatar'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: Dimensions.height100 * 1.5,
          width: Dimensions.width100 * 1.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: _getImageProvider(),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: GestureDetector(
            onTap: _showSourceSelector,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.black54,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt,
                color: isDark ? Colors.white : Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }}