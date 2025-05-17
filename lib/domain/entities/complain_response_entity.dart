import 'package:rental_service/domain/entities/pagination.dart';

import 'complain_entity.dart';

class ComplainResponseEntity {
  final int statusCode;
  final String message;
  final ComplainDataEntity data;
  final PaginationEntity pagination;

  ComplainResponseEntity({
    required this.statusCode,
    required this.message,
    required this.data,
    required this.pagination
  });
}

class ComplainDataEntity {
  final List<ComplainEntity> list;

  ComplainDataEntity({required this.list});
}