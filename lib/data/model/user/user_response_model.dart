import 'package:rental_service/data/model/user/user_info_model.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/user_info_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required int statusCode,
    required String message,
    required String token,
    required refreshToken,
    required UserInfoEntity userInfo,
  }) : super(
    statusCode: statusCode,
    message: message,
    token: token,
    refreshToken:refreshToken,
    userInfo: userInfo,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      statusCode: json['statusCode'] as int,
      message: json['message'],
      token: json['data']['token'],
      refreshToken: json['data']['refreshToken'],
      userInfo: UserInfoModel.fromJson(json['data']['userInfo']),
    );
  }
}