

import '../../domain/entities/complain_entity.dart';
import '../../domain/entities/complain_response_entity.dart';
import 'ComplainModel.dart';

class ComplainResponseModel extends ComplainResponseEntity {
  ComplainResponseModel({
    required super.statusCode,
    required super.message,
    required super.data,
  });

  factory ComplainResponseModel.fromJson(Map<String, dynamic> json) {
    return ComplainResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: ComplainDataEntity(
        list: (json['data']['list'] as List)
            .map((e) => ComplainModel.fromJson(e).toEntity())
            .toList(),
      ),
    );
  }
}
