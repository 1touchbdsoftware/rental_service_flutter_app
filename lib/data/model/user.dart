import 'package:rental_service/data/model/user_info_model.dart';
import 'package:rental_service/domain/entities/user_entity.dart';



class UserModel extends UserEntity {
  UserModel({
    required int statusCode,
    required String message,
    required String token,
    required UserInfo userInfo,
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
      userInfo: UserInfo.fromJson(json['data']['userInfo']),
    );
  }
}


