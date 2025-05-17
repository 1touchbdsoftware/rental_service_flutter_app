import '../../../domain/entities/complain_entity.dart';
import '../../../domain/entities/complain_response_entity.dart';
import '../../../domain/entities/pagination.dart';
import 'ComplainModel.dart';

class ComplainResponseModel extends ComplainResponseEntity {
  ComplainResponseModel({
    required super.statusCode,
    required super.message,
    required super.data,
    required super.pagination
  });

  //convert the response json to model to entity
  // json -> model -> entity
  factory ComplainResponseModel.fromJson(Map<String, dynamic> json) {
    return ComplainResponseModel(
      statusCode: json['statusCode'],
      message: json['message'],
      data: ComplainDataEntity(
        list: (json['data']['list'] as List)
            .map((e) => ComplainModel.fromJson(e).toEntity())
            .toList(),
      ),
      pagination: PaginationEntity(
        pageNumber: json['pagination']['pageNumber'],
        pageSize: json['pagination']['pageSize'],
        totalRows: json['pagination']['totalRows'],
        totalPages: json['pagination']['totalPages'],
      ),
    );
  }
}


