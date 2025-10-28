import 'package:rental_service/domain/entities/user_info_entity.dart';

import '../../data/model/user/user_info_model.dart';

class UserEntity {
  final int statusCode;
  final String message;
  final String token;
  final String refreshToken;
  final UserInfoEntity userInfo;

  const UserEntity({
    required this.statusCode,
    required this.message,
    required this.token,
    required this.refreshToken,
    required this.userInfo,
  });
}

class UserModel extends UserEntity {
  UserModel({
    required int statusCode,
    required String message,
    required String token,
    required String refreshToken,
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
      statusCode: json['statusCode'],
      message: json['message'],
      token: json['data']['token'],
      refreshToken: json['data']['refreshToken'],
      userInfo: UserInfoModel.fromJson(json['data']['userInfo']),
    );
  }
}