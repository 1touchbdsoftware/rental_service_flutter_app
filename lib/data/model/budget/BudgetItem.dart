class BudgetItem {
  final String description;
  final double quantity;
  final double costPerUnit;
  final double total;

  BudgetItem({
    required this.description,
    required this.quantity,
    required this.costPerUnit,
    required this.total,
  });

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      description: json['description'],
      quantity: json['quantity'].toDouble(),
      costPerUnit: json['costPerUnit'].toDouble(),
      total: json['total'].toDouble(),
    );
  }
}