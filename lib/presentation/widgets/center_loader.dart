import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class CenterLoader extends StatelessWidget {
  final Color? color;
  final double? size;

  const CenterLoader({
    super.key,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the platform is iOS or Android
    if (Platform.isIOS) {
      // Use CupertinoActivityIndicator for iOS
      return Center(
        child: SizedBox(
          width: size ?? 50.0,
          height: size ?? 50.0,
          child: CupertinoActivityIndicator(
            radius: size ?? 20.0, // Adjust size here
          ),
        ),
      );
    } else if (Platform.isAndroid) {
      // Customize Android-specific loader behavior here
      return Center(
        child: SizedBox(
          width: size ?? 50.0,
          height: size ?? 50.0,
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Colors.black,
            ),
          ),
        ),
      );
    } else {
      // Default fallback for other platforms if needed
      return Center(
        child: SizedBox(
          width: size ?? 50.0,
          height: size ?? 50.0,
          child: CircularProgressIndicator(
            strokeWidth: 4.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Colors.black,
            ),
          ),
        ),
      );
    }
  }
}

class CenterLoaderWithText extends StatelessWidget {
  final String? text;
  final Color? loaderColor;
  final Color? textColor;
  final double? loaderSize;

  const CenterLoaderWithText({
    super.key,
    this.text,
    this.loaderColor,
    this.textColor,
    this.loaderSize,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CenterLoader(
            color: loaderColor ?? Colors.black,
            size: loaderSize,
          ),
          if (text != null) ...[
            const SizedBox(height: 16),
            Text(
              text!,
              style: TextStyle(
                color: textColor ?? Colors.black,
                fontSize: 16,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
