

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/core/constants/api_urls.dart';
import 'package:rental_service/core/network/dio_client.dart';
import 'package:rental_service/data/model/user/signin_req_params.dart';


import '../../../service_locator.dart';


//we will call the api from here
abstract class AuthApiService{

  Future<Either> signup();

  Future<Either> signin(SignInReqParams signinReq);


}

class AuthApiServiceImpl extends AuthApiService{


  @override
  Future<Either> signup() {

    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Either> signin(SignInReqParams signinReq) async{
    try{
      var response = await sl<DioClient>().post(ApiUrls.signin, data: signinReq.toJson());
      return Right(response);
    }on DioException catch(e){

      return Left(e.response!.data['message']);
    }
  }


}