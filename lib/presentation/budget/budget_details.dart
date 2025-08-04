import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EstimatedBudgetScreen extends StatelessWidget {
  final List<BudgetItem> items = const [
    BudgetItem(description: 'Venue Rental', quantity: 1, unitPrice: 5000),
    BudgetItem(description: 'Catering (per person)', quantity: 50, unitPrice: 25),
    BudgetItem(description: 'AV Equipment', quantity: 1, unitPrice: 1500),
    BudgetItem(description: 'Decorations', quantity: 1, unitPrice: 800),
  ];

  const EstimatedBudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final double totalBudget = items.fold(0, (sum, item) => sum + item.total);
    final currencyFormat = NumberFormat.currency(symbol: '৳', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(
         "Estimated Budget",
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onPrimary),
        ),
        backgroundColor: colorScheme.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Table Header
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: const _TableHeaderRow(),
              ),
              const SizedBox(height: 8),
        
              // Table Content
              Expanded(
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _BudgetItemRow(
                      item: item,
                      currencyFormat: currencyFormat,
                    );
                  },
                ),
              ),
        
              const Divider(height: 24),
        
              // Total Budget
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
                  borderRadius: BorderRadius.circular(8), // <-- Added missing borderRadius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Budget:',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currencyFormat.format(totalBudget),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
        
              const SizedBox(height: 24),
        
              // Action Buttons
              _ActionButtons(
                onReviewPressed: () => _handleReviewRequest(context),
                onPayPressed: () => _handlePayment(context, totalBudget),
                colorScheme: colorScheme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleReviewRequest(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Budget review requested')),
    );
  }

  void _handlePayment(BuildContext context, double amount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Text('Proceed with payment of \$${amount.toStringAsFixed(2)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment of \$${amount.toStringAsFixed(2)} processed')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}

class _TableHeaderRow extends StatelessWidget {
  const _TableHeaderRow();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            'Description',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            'Qty',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Unit Price',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            'Total',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _BudgetItemRow extends StatelessWidget {
  final BudgetItem item;
  final NumberFormat currencyFormat;

  const _BudgetItemRow({
    required this.item,
    required this.currencyFormat,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.description,
              style: textTheme.bodyMedium,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              item.quantity.toString(),
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(item.unitPrice),
              style: textTheme.bodyMedium,
              textAlign: TextAlign.end,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(item.total),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onReviewPressed;
  final VoidCallback onPayPressed;
  final ColorScheme colorScheme;

  const _ActionButtons({
    required this.onReviewPressed,
    required this.onPayPressed,
    required this.colorScheme
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.reviews_outlined),
            onPressed: onReviewPressed,
            label: const Text('Request Review'),
            style: OutlinedButton.styleFrom(
              foregroundColor: colorScheme.primary,
              side: BorderSide(color: colorScheme.primary),
            )

          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.payment_outlined),
            onPressed: onPayPressed,
            label: const Text('Pay Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
            )

          ),
        ),
      ],
    );
  }
}

class BudgetItem {
  final String description;
  final int quantity;
  final double unitPrice;

  const BudgetItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}
