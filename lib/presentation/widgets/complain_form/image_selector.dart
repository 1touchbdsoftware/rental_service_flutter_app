import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// A reusable widget for image picking functionality
class ImagePickerWidget extends StatefulWidget {
  final List<XFile> selectedImages;
  final int maxImages;
  final Function(XFile) onImageAdded;
  final Function(int) onImageRemoved;
  final Function() onClearImages;

  const ImagePickerWidget({
    Key? key,
    required this.selectedImages,
    this.maxImages = 15,
    required this.onImageAdded,
    required this.onImageRemoved,
    required this.onClearImages,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Attach Images",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Image Grid
              if (widget.selectedImages.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: widget.selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(widget.selectedImages[index].path),
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => widget.onImageRemoved(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 12),

              // Add Image Button
              if (widget.selectedImages.length < widget.maxImages)
                InkWell(
                  onTap: () => _showImageSourceSelector(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_a_photo, size: 32),
                        SizedBox(height: 4),
                        Text('Add Photos'),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.selectedImages.length}/${widget.maxImages} images',
              style: TextStyle(
                fontSize: 12,
                color: widget.selectedImages.length >= widget.maxImages
                    ? Colors.red
                    : Colors.black,
              ),
            ),
            if (widget.selectedImages.isNotEmpty)
              TextButton(
                onPressed: widget.onClearImages,
                child: const Text('Clear all'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showImageSourceSelector(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Take Photo Option
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickFromCamera();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.camera_alt, size: 36),
                      SizedBox(height: 8),
                      Text("Take Photo"),
                    ],
                  ),
                ),
                // Choose from Gallery Option
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImagesFromGallery();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.photo_library, size: 36),
                      SizedBox(height: 8),
                      Text("Choose from Gallery"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickFromCamera() async {
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      await _openCamera();
    } else if (cameraStatus.isDenied) {
      // Request permission
      final result = await Permission.camera.request();
      if (result.isGranted) {
        await _openCamera();
      } else {
        _showPermissionDeniedMessage(context, 'Camera');
      }
    }
  }

  Future<void> _openCamera() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      maxWidth: 1000,
    );

    if (pickedFile != null && widget.selectedImages.length < widget.maxImages) {
      widget.onImageAdded(pickedFile);
    } else if (widget.selectedImages.length >= widget.maxImages) {
      _showMaxImagesMessage(context);
    }
  }

  Future<void> _pickImagesFromGallery() async {
    final galleryStatus = await Permission.photos.status;
    if (galleryStatus.isGranted) {
      await _openGallery();
    } else if (galleryStatus.isDenied) {
      final result = await Permission.photos.request();
      if (result.isGranted) {
        await _openGallery();
      } else {
        _showPermissionDeniedMessage(context, 'Gallery');
      }
    }
  }

  Future<void> _openGallery() async {
    if (widget.selectedImages.length >= widget.maxImages) {
      _showMaxImagesMessage(context);
      return;
    }

    final imagePicker = ImagePicker();
    final pickedImages = await imagePicker.pickMultiImage(
      imageQuality: 70,
      maxWidth: 1000,
    );

    if (pickedImages.isNotEmpty) {
      final remainingSlots = widget.maxImages - widget.selectedImages.length;
      final imagesToAdd = pickedImages.length > remainingSlots
          ? pickedImages.sublist(0, remainingSlots)
          : pickedImages;

      for (var image in imagesToAdd) {
        widget.onImageAdded(image);
      }

      if (pickedImages.length > remainingSlots) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Only added ${imagesToAdd.length} images. Maximum limit reached.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  void _showMaxImagesMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Maximum ${widget.maxImages} images allowed'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showPermissionDeniedMessage(BuildContext context, String source) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$source permission denied'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

/// A reusable submit button with loading state
class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String buttonText;
  final IconData icon;

  const SubmitButton({
    Key? key,
    required this.onPressed,
    this.isLoading = false,
    this.buttonText = "SUBMIT",
    this.icon = Icons.send,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(color: Colors.white),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(buttonText),
        ],
      ),
    );
  }
}