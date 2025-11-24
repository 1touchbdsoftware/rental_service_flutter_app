import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../l10n/generated/app_localizations.dart';

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
    // Get theme colors
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).attachImages,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.outline),
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
                              color: colorScheme.surfaceContainerHighest,
                              child: Icon(
                                Icons.error,
                                color: colorScheme.error,
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
                                color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.close,
                                color: colorScheme.onSurface,
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
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colorScheme.outline,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo,
                          size: 32,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add Photos',
                          style: textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${widget.selectedImages.length}/${widget.maxImages} images',
              style: textTheme.bodySmall?.copyWith(
                color: widget.selectedImages.length >= widget.maxImages
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            ),
            if (widget.selectedImages.isNotEmpty)
              TextButton(
                onPressed: widget.onClearImages,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  S.of(context).clearAll,
                  style: textTheme.labelMedium,
                ),
              ),
          ],
        ),
      ],
    );
  }

  void _showImageSourceSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      backgroundColor: colorScheme.surface,
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
                    await _openCamera();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 36,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).takePhoto,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                // Choose from Gallery Option
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await _openGallery();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.photo_library,
                        size: 36,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        S.of(context).chooseFromGallery,
                        style: textTheme.labelMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
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
              S.of(context).onlyAddedImagestoaddLengthImagesMaximumLimitReached(imagesToAdd.length.toString()),
            ),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    }
  }

  void _showMaxImagesMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).maximumImagesAllowed(widget.maxImages.toString()),),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}