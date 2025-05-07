import 'package:rental_service/data/model/user_info_model.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/entities/user_info_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required int statusCode,
    required String message,
    required String token,
    required UserInfoEntity userInfo,
  }) : super(
    statusCode: statusCode,
    message: message,
    token: token,
    userInfo: userInfo,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      statusCode: json['statusCode'],
      message: json['message'],
      token: json['data']['token'],
      userInfo: UserInfoModel.fromJson(json['data']['userInfo']),
    );
  }
}