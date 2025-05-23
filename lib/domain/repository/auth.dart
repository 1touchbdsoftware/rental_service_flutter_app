



import 'package:dartz/dartz.dart';
import 'package:rental_service/data/model/user/signin_req_params.dart';

abstract class AuthRepository{


  //Either is from dart z package
  Future<Either> signup();

  Future<Either<String, bool>> signin(SignInReqParams signinReq);
  Future<bool> isLoggedIn();
  Future<Either> logout();


}