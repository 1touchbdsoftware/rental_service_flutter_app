import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    List<Widget> pageButtons = [];
    for (int i = 1; i <= totalPages; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextButton(
            onPressed: () => onPageChanged(i),
            child: Text(
              '$i',
              style: TextStyle(
                fontWeight: i == currentPage ? FontWeight.bold : FontWeight.normal,
                color: i == currentPage ? Colors.blueAccent : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentPage > 1)
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => onPageChanged(currentPage - 1),
            ),
          ...pageButtons,
          if (currentPage < totalPages)
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onPageChanged(currentPage + 1),
            ),
        ],
      ),
    );
  }
}
