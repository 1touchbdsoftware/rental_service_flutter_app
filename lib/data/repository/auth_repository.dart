import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/signin_req_params.dart';
import 'package:rental_service/data/model/user.dart';
import 'package:rental_service/data/source/auth_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/auth.dart';
import '../../service_locator.dart';
import '../source/auth_local_service.dart';

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

        // Convert to model
        final userModel = UserModel.fromJson(response.data);

        // Save token
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('token', userModel.token);
        sharedPreferences.setString('userName', userModel.userInfo.userName);
        sharedPreferences.setString('tenantName', userModel.userInfo.tenantName!);
        sharedPreferences.setString('agencyID', userModel.userInfo.agencyID);
        sharedPreferences.setString('tenantID', userModel.userInfo.tenantID!);
        sharedPreferences.setString('landlordID', userModel.userInfo.landlordID!);
        sharedPreferences.setString('propertyID', userModel.userInfo.propertyID!);
        sharedPreferences.setString('agencyID', userModel.userInfo.agencyID);


        final userType = userModel.userInfo.registrationType;

        if(userType == "LANDLORD") {
          sharedPreferences.setString('userType', "LANDLORD");
        }else if (userType == "TENANT"){
          sharedPreferences.setString('userType', "TENANT");
        }else{
          sharedPreferences.setString('userType', "");
        }

        //check registrationType and save name also from landlordName

        // Return as entity
        return Right(userModel); // Since UserModel extends UserEntity

        // return Right(response);
      },
    );
  }



  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthLocalService>().isLoggedIn();
  }



  @override
  Future<Either> logout() async {
    return await sl<AuthLocalService>().logout();
  }



}
