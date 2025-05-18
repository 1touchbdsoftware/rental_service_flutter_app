import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/// A reusable text input field for multiline text entry
class MultilineTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final IconData prefixIcon;
  final String? helperText;
  final int maxLines;

  const MultilineTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.hintText = "Enter text here...",
    this.prefixIcon = Icons.description,
    this.helperText,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Padding(
              padding: EdgeInsets.only(bottom: (maxLines - 1) * 16.0),
              child: Icon(prefixIcon, color: Colors.black87),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black54),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black54),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black),
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black54),
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: validator,
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              helperText!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }
}
