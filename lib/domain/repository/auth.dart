



import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/user/signin_req_params.dart';

import '../../data/model/api_failure.dart';
import '../../data/model/password/change_password_request.dart';

abstract class AuthRepository{


  //Either is from dart z package
  Future<Either> signup();

  Future<Either<String, bool>> signin(SignInReqParams signinReq);
  Future<bool> isLoggedIn();
  Future<Either> logout();
  Future<Either<String, bool>> changePassword(ChangePasswordRequest params);
  Future<Either<String, bool>> forgotPassword(String email);
  Future<Either<String, bool>> verifyOtp(String email);

// Add these new methods
  Future<Either<String, Map<String, dynamic>>> validateToken(String userName, String accessToken);
  Future<Either<String, Map<String, dynamic>>> refreshToken(String accessToken, String refreshToken);

}