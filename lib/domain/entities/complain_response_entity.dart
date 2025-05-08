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

  ComplainDataEntity({required this.list});
}