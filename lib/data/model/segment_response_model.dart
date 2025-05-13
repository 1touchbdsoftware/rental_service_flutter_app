import 'segment_model.dart';

class SegmentResponseModel {
  final int statusCode;
  final String message;
  final List<SegmentModel> data;

  SegmentResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory SegmentResponseModel.fromJson(Map<String, dynamic> json) {
    return SegmentResponseModel(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => SegmentModel.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
      'data': data.map((segment) => segment.toJson()).toList(),
    };
  }
}
