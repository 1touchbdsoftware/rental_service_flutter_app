import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/signin_req_params.dart';
import 'package:rental_service/data/source/auth_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/auth.dart';
import '../../service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup() {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Either> signin(SignInReqParams signinReq) async {
    Either result = await sl<AuthApiService>().signin(signinReq);

    return result.fold(
      (error) {
        return Left(error);
      },

      (data) async {
        Response response = data;
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        sharedPreferences.setString('token', response.data['token']);
        return Right(response);
      },
    );
  }
}
