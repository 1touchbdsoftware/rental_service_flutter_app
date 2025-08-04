
import '../pagination_model.dart';
import 'BudgetItem.dart';

class BudgetResponse {
  final int statusCode;
  final String message;
  final BudgetData data;

  BudgetResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory BudgetResponse.fromJson(Map<String, dynamic> json) {
    return BudgetResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: BudgetData.fromJson(json['data']),
    );
  }
}

class BudgetData {
  final List<BudgetItem> list;
  final Pagination pagination;

  BudgetData({
    required this.list,
    required this.pagination,
  });

  factory BudgetData.fromJson(Map<String, dynamic> json) {
    return BudgetData(
      list: (json['list'] as List)
          .map((item) => BudgetItem.fromJson(item))
          .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}


