

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/core/constants/api_urls.dart';
import 'package:rental_service/core/network/dio_client.dart';
import 'package:rental_service/data/model/user/signin_req_params.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../../service_locator.dart';
import '../../model/api_failure.dart';
import '../../model/password/change_password_request.dart';
import '../../model/user/device_token_request.dart';


//we will call the api from here
abstract class AuthApiService{
  Future<Either> signup();
  Future<Either<ApiFailure, Response>> signin(SignInReqParams signinReq);
  Future<Either<ApiFailure, Response>> changePassword(ChangePasswordRequest params);
  Future<Either<ApiFailure, Response>> forgotPasswordRequest(String email);
  Future<Either<ApiFailure, Response>> verifyOtp(String otp);


}

class AuthApiServiceImpl extends AuthApiService{

  @override
  Future<Either> signup() {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Either<ApiFailure, Response>> signin(SignInReqParams signinReq) async {
    try {
      var response = await sl<DioClient>().post(ApiUrls.signin, data: signinReq.toJson());

      // Check if response is successful and call saveDeviceToken
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        // Extract user ID from response data
        final userId = response.data['data']['userInfo']['id']?.toString();

        if (userId != null && userId.isNotEmpty) {
          await _saveDeviceToken(userId);
        } else {
          print('User ID not found in response');
        }
      }

      return Right(response);
    } on DioException catch(e) {
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));
    }
  }

  Future<void> _saveDeviceToken(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('fcm_token');

      if (token == null) {
        print('FCM token not found in shared preferences');
        return;
      }

      // Create device input request
      final deviceRequest = DeviceInputRequest(
        userId: userId,
        deviceToken: token,
        platform: 'app',
      );

      // Make API call to save device token
      await sl<DioClient>().post(
        ApiUrls.saveDeviceToken,
        data: deviceRequest.toJson(),
      );

      print('Device token saved successfully for user: $userId');

    } catch (e) {
      print('Error saving device token: $e');
      // Note: We don't throw or return failure here since this is a secondary operation
      // that shouldn't affect the main signin flow
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
      var response = await Dio().post(
        ApiUrls.forgotPassword,
        data: requestData,
        options: Options(validateStatus: (status) => status! < 500), // Accept 4xx status codes
      );

      // Check response status code
      if (response.statusCode == 404) {
        return Left(ApiFailure('Email Not Found in Our Database'));
      } else if(response.statusCode == 400){
        return Left(ApiFailure('Email Not Valid'));
      } else if (response.statusCode != 200) {
        // Handle other non-success status codes
        final errorMsg = response.data?['message']?.toString() ??
            'Request failed with status ${response.statusCode}';
        return Left(ApiFailure(errorMsg));
      }
      return Right(response); // Return success
    } on DioException catch (e) {
      // Handle Dio-specific errors (connection issues, etc.)
      if (e.response?.statusCode == 404) {
        return Left(ApiFailure('Invalid email'));
      }
      return Left(ApiFailure("Something Went Wrong."));
    } catch (e) {
      return Left(ApiFailure("Something Went Wrong.")); // Return other errors
    }
  }

  @override
  Future<Either<ApiFailure, Response>> verifyOtp(String otp) async {
    try {
      // Retrieve the email from SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('email') ?? '';

      if (email.isEmpty) {
        return Left(ApiFailure('No email found in SharedPreferences.'));
      }

      final data = {
        "email": email,
        "otp": otp,
      };

      print("service - verify called: $email, $otp");

      // Make the API call
      final response = await Dio().post(
        ApiUrls.verifyOtp,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      return Right(response);
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['message']?.toString() ??
          e.message ??
          'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(ApiFailure(errorMsg));
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

}