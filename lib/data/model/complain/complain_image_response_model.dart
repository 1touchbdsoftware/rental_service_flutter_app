
import 'complain_image_model.dart';

class ComplainImageResponseModel {
  final int statusCode;
  final String message;
  final List<ComplainImageModel> data;

  ComplainImageResponseModel({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ComplainImageResponseModel.fromJson(Map<String, dynamic> json) {
    return ComplainImageResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => ComplainImageModel.fromJson(e))
          .toList(),
    );
  }
}
