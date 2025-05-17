import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final int visiblePageCount;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
    this.visiblePageCount = 5, // how many pages to show at once
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();

    final List<Widget> pageButtons = [];

    int startPage = (currentPage - (visiblePageCount ~/ 2)).clamp(1, totalPages);
    int endPage = (startPage + visiblePageCount - 1).clamp(1, totalPages);

    // Adjust startPage if endPage reached totalPages
    startPage = (endPage - visiblePageCount + 1).clamp(1, totalPages);

    if (startPage > 1) {
      pageButtons.add(_buildPageButton(1));
      if (startPage > 2) {
        pageButtons.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text("..."),
        ));
      }
    }

    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(_buildPageButton(i, isCurrent: i == currentPage));
    }

    if (endPage < totalPages) {
      if (endPage < totalPages - 1) {
        pageButtons.add(const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text("..."),
        ));
      }
      pageButtons.add(_buildPageButton(totalPages));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
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
        ),
      ),
    );
  }

  Widget _buildPageButton(int page, {bool isCurrent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => onPageChanged(page),
        child: Text(
          '$page',
          style: TextStyle(
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            color: isCurrent ? Colors.blueAccent : Colors.black,
          ),
        ),
      ),
    );
  }
}
