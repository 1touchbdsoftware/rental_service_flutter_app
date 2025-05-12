import 'package:flutter/material.dart';

class CenterLoader extends StatelessWidget {
  final Color? color;
  final double? size;

  const CenterLoader({
    super.key,
    this.color,
    this.size
  });

  @override
  Widget build(BuildContext context) {
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
    this.loaderSize
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