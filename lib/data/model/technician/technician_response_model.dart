import 'package:rental_service/data/model/technician/technician_data_model.dart';

class TechnicianResponse {
  final int statusCode;
  final String message;
  final TechnicianData data;

  TechnicianResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory TechnicianResponse.fromJson(Map<String, dynamic> json) {
    return TechnicianResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      data: TechnicianData.fromJson(json['data']),
    );
  }
}
