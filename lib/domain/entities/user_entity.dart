import 'package:rental_service/domain/entities/user_info_entity.dart';

class UserEntity {
  final int statusCode;
  final String message;
  final String token;
  final UserInfoEntity userInfo;

  const UserEntity({
    required this.statusCode,
    required this.message,
    required this.token,
    required this.userInfo,
  });
}
