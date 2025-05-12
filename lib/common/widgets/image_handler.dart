import 'dart:convert';
import 'package:flutter/material.dart';

class Base64ImageHandler {
  static Widget buildBase64Image({
    required String? base64String,
    double width = 80,
    double height = 80,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    VoidCallback? onTap,
  }) {
    // If base64String is null or empty, return a placeholder
    if (base64String == null || base64String.isEmpty) {
      return _buildPlaceholder(width, height);
    }

    try {
      // Remove any header if present (e.g., "data:image/png;base64,")
      final cleanBase64 = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;

      // Decode the base64 string
      final bytes = base64Decode(cleanBase64);

      // Wrap with GestureDetector if onTap is provided
      Widget imageWidget = ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        child: Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(width, height);
          },
        ),
      );

      return onTap != null
          ? GestureDetector(
        onTap: onTap,
        child: imageWidget,
      )
          : imageWidget;
    } catch (e) {
      // If decoding fails, return a placeholder
      return _buildPlaceholder(width, height);
    }
  }

  static Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(Icons.broken_image),
    );
  }
}