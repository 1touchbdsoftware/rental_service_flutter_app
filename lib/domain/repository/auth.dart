



import 'package:dartz/dartz.dart';
import 'package:rental_service/data/model/signin_req_params.dart';

abstract class AuthRepository{


  //from dart z package
  Future<Either> signup();

  Future<Either> signin(SignInReqParams signinReq);
  Future<bool> isLoggedIn();
  Future<Either> logout();


}