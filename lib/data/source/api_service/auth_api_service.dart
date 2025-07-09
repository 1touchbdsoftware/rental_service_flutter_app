

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/core/constants/api_urls.dart';
import 'package:rental_service/core/network/dio_client.dart';
import 'package:rental_service/data/model/user/signin_req_params.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../service_locator.dart';
import '../../model/api_failure.dart';
import '../../model/password/change_password_request.dart';


//we will call the api from here
abstract class AuthApiService{
  Future<Either> signup();
  Future<Either<ApiFailure, Response>> signin(SignInReqParams signinReq);
  Future<Either<ApiFailure, Response>> changePassword(ChangePasswordRequest params);
  Future<Either<ApiFailure, Response>> forgotPasswordRequest(String email);

}

class AuthApiServiceImpl extends AuthApiService{

  @override
  Future<Either> signup() {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiFailure, Response>> signin(SignInReqParams signinReq) async{
    try{
      var response = await sl<DioClient>().post(ApiUrls.signin, data: signinReq.toJson());
      return Right(response);
    }on DioException catch(e){

      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));
    }
  }

 @override
  Future<Either<ApiFailure, Response>> changePassword(ChangePasswordRequest params) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      // Convert params to JSON for POST request body
      final requestBody = params.toJson();

      // Make POST request to the change password endpoint
      final response = await Dio().post(
        ApiUrls.resetPassword,
        data: requestBody,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      return Right(response);  // Return the response as a success
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));  // Return failure message
    } catch (e) {
      return Left(ApiFailure(e.toString()));  // Return any other errors
    }
  }

  @override
  Future<Either<ApiFailure, Response>> forgotPasswordRequest(String email) async {
    try {
      // Prepare the request data (email only)
      final requestData = {"email": email};

      // Make the API call for forgot password request
      var response = await Dio().post(ApiUrls.forgotPassword, data: requestData);

      return Right(response); // Return success
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg)); // Return failure
    } catch (e) {
      return Left(ApiFailure(e.toString())); // Return other errors
    }
  }


}