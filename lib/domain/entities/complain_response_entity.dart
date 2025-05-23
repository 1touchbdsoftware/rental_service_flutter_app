import 'package:rental_service/domain/entities/pagination.dart';

import 'complain_entity.dart';

class ComplainResponseEntity {
  final int statusCode;
  final String message;
  final ComplainDataEntity data;


  ComplainResponseEntity({
    required this.statusCode,
    required this.message,
    required this.data,
  });
}

class ComplainDataEntity {
  final List<ComplainEntity> list;
  final PaginationEntity pagination;

  ComplainDataEntity({required this.list, required this.pagination});
}