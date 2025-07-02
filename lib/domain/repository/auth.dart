



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


}