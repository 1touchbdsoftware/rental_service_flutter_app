import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/complain/complain_req_params/complain_post_req_params.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/dio_client.dart';

import '../../../service_locator.dart';
import '../../model/api_failure.dart';
import '../../model/complain/complain_response_model.dart';
import '../../model/get_complain_req_params.dart';

abstract class ComplainApiService {
  // Change type to accept nullable String to match implementation
  Future<Either<ApiFailure, Response>> getComplains(GetComplainsParams params);

  Future<Either<ApiFailure, Response>> saveComplain(ComplainPostModel model);

}

class ComplainApiServiceImpl implements ComplainApiService {
  ComplainApiServiceImpl();

  @override
  Future<Either<ApiFailure, Response>> getComplains(
      GetComplainsParams params) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get token from SharedPreferences
      final token = prefs.getString('token');
      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final queryParams = {
        'AgencyID': params.agencyID,
        'PageNumber': params.pageNumber.toString(),
        'PageSize': params.pageSize.toString(),
        'IsActive': params.isActive.toString(),
        if (params.landlordID != null) 'LandlordID': params.landlordID,
        if (params.propertyID != null) 'PropertyID': params.propertyID,
        if (params.tenantID != null) 'TenantID': params.tenantID,
        'Flag': params.flag,
        'tab': params.tab,
      };

      final response = await sl<DioClient>().get(
        ApiUrls.getComplainInfo,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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


  @override
  Future<Either<ApiFailure, Response>> saveComplain(ComplainPostModel model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final formData = await model.toFormData();


      print('Sending to ${ApiUrls.saveComplain}');
      print('Headers: Authorization: Bearer $token');
      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files.map((e) => e.key + ' -> ' + (e.value.filename ?? ''))}');


      final response = await sl<DioClient>().post(
        ApiUrls.saveComplain,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
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
