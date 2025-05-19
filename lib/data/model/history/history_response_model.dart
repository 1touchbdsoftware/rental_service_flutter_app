
import 'history_data_model.dart';

class HistoryResponseModel {
  final int statusCode;
  final String message;
  final HistoryData data;

  HistoryResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return HistoryResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: HistoryData.fromJson(json['data']),
    );
  }
}
