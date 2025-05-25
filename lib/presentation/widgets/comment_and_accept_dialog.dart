import 'package:flutter/material.dart';

class CommentDialog extends StatelessWidget {
  final String title;
  final String ticketNo;
  final String labelText;
  final String hintText;
  final String actionButtonText;
  final Color actionButtonColor;
  final ValueChanged<String> onSubmitted;
  final TextEditingController controller;

  const CommentDialog({
    super.key,
    required this.title,
    required this.ticketNo,
    required this.labelText,
    required this.hintText,
    required this.actionButtonText,
    required this.actionButtonColor,
    required this.onSubmitted,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          Text(ticketNo),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Write your Comment Here:'),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
              hintText: hintText,
            ),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please provide comments')),
              );
              return;
            }
            onSubmitted(controller.text.trim());
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: actionButtonColor,
          ),
          child: Text(actionButtonText),
        ),
      ],
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String ticketNo,
    required String labelText,
    required String hintText,
    required String actionButtonText,
    required Color actionButtonColor,
    required ValueChanged<String> onSubmitted,
  }) {
    final controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => CommentDialog(
        title: title,
        ticketNo: ticketNo,
        labelText: labelText,
        hintText: hintText,
        actionButtonText: actionButtonText,
        actionButtonColor: actionButtonColor,
        onSubmitted: onSubmitted,
        controller: controller,
      ),
    );
  }
}