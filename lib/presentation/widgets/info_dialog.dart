import 'package:flutter/material.dart';

class SimpleInfoDialog extends StatelessWidget {
  final String title;
  final String bodyText;
  final Color backgroundColor;
  final Color textColor;

  const SimpleInfoDialog({
    Key? key,
    required this.title,
    required this.bodyText,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Center(
        child: Text(
          title,
          style: TextStyle(color: textColor),
          textAlign: TextAlign.center,
        ),
      ),
      content: SingleChildScrollView(
        child: Text(
          bodyText,
          style: TextStyle(color: textColor),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: TextStyle(color: textColor)),
        ),
      ],
    );
  }
}
