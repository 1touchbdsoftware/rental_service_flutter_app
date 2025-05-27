import 'package:flutter/material.dart';

class CommentDialog extends StatefulWidget {
  final String title;
  final String ticketNo;
  final String labelText;
  final String hintText;
  final String actionButtonText;
  final Color actionButtonColor;
  final Future<void> Function(String) onSubmitted;

  const CommentDialog({
    super.key,
    required this.title,
    required this.ticketNo,
    required this.labelText,
    required this.hintText,
    required this.actionButtonText,
    required this.actionButtonColor,
    required this.onSubmitted,
  });

  @override
  State<CommentDialog> createState() => _CommentDialogState();

  // Static show method
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String ticketNo,
    required String labelText,
    required String hintText,
    required String actionButtonText,
    required Color actionButtonColor,
    required Future<void> Function(String) onSubmitted,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CommentDialog(
        title: title,
        ticketNo: ticketNo,
        labelText: labelText,
        hintText: hintText,
        actionButtonText: actionButtonText,
        actionButtonColor: actionButtonColor,
        onSubmitted: onSubmitted,
      ),
    );
  }
}

class _CommentDialogState extends State<CommentDialog> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide comments')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.onSubmitted(_controller.text.trim());
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.title),
          Text(widget.ticketNo),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Write your Comment Here:'),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: widget.labelText,
                border: const OutlineInputBorder(),
                hintText: widget.hintText,
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.actionButtonColor,
          ),
          child: _isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : Text(widget.actionButtonText),
        ),
      ],
    );
  }
}