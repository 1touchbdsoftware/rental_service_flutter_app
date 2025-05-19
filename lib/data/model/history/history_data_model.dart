

import '../pagination_model.dart';
import 'history_model.dart';

class HistoryData {
  final List<History> list;
  final Pagination pagination;

  HistoryData({
    required this.list,
    required this.pagination,
  });

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      list: List<History>.from(json['list'].map((item) => History.fromJson(item))),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}
