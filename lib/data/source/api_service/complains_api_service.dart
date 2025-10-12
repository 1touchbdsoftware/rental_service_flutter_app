import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/complain/complain_req_params/complain_post_req.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/dio_client.dart';

import '../../../service_locator.dart';
import '../../model/api_failure.dart';
import '../../model/budget/budget_post_model.dart';
import '../../model/complain/complain_image_model.dart';
import '../../model/complain/complain_req_params/complain_edit_post.dart';
import '../../model/complain/complain_req_params/completed_post_req.dart';
import '../../model/complain/complain_req_params/recomplain_post_req.dart';
import '../../model/complain/complain_response_model.dart';
import '../../model/complain/complain_req_params/get_complain_req_params.dart';
import '../../model/landlord_request/complain_aproval_request_post.dart';

abstract class ComplainApiService {
  // Change type to accept nullable String to match implementation
  Future<Either<ApiFailure, Response>> getComplains(GetComplainsParams params);
  Future<Either<ApiFailure, Response>> saveComplain(ComplainPostModel model);
  Future<Either<ApiFailure, Response>> editComplain(ComplainEditPostParams model);
  Future<Either<ApiFailure, Response>> reComplain(ReComplainParams model);
  Future<Either<ApiFailure, Response>> markAsCompleted(ComplainCompletedRequest model);
  Future<Either<ApiFailure, List<ComplainImageModel>>> getComplainImages(String complainID, String agencyID);
  Future<Either<ApiFailure, Response>> approveComplaints(ComplainApprovalRequestModel model);

  Future<Either<ApiFailure, Response>> getBudgetForComplain({ required String complainID});
  Future<Either<ApiFailure, Response>> postAcceptBudget(BudgetPostModel model, bool isReview);

  Future<Either<ApiFailure, Response>> getAgencyInfo(String agencyID);

}

class ComplainApiServiceImpl implements ComplainApiService {
  ComplainApiServiceImpl();

  @override
  Future<Either<ApiFailure, Response>> getComplains(
      GetComplainsParams params) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = '';
      // Get token from SharedPreferences
      final token = prefs.getString('token');
      //get user type
      final userType = prefs.getString('userType');

      if(userType=="TENANT"){
        url = ApiUrls.getComplainInfo;
      }else if(userType =="LANDLORD"){
        url = ApiUrls.getComplainInfoLandlord;
      }else{
        url = ApiUrls.baseURL;
      }

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final queryParams = {
        'AgencyID': params.agencyID,
        'PageNumber': params.pageNumber.toString(),
        'PageSize': params.pageSize.toString(),
        if (params.isActive != null) 'IsActive': params.isActive.toString(),
        if (params.landlordID != null) 'LandlordID': params.landlordID,
        if (params.propertyID != null) 'PropertyID': params.propertyID,
        if (params.tenantID != null) 'TenantID': params.tenantID,
        'Flag': params.flag,
        'tab': params.tab,
      };

      final response = await sl<DioClient>().get(
        url,
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
  Future<Either<ApiFailure, List<ComplainImageModel>>> getComplainImages(
      String complainID, String agencyID) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final response = await sl<DioClient>().get(
        ApiUrls.getComplainImages,
        queryParameters: {
          'complainID': complainID,
          'agencyID': agencyID,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Expecting response.data to be a map with a 'data' field containing the list
      if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        final images = (response.data['data'] as List)
            .map((json) => ComplainImageModel.fromJson(json))
            .toList();
        return Right(images);
      } else {
        return Left(ApiFailure('Invalid response format'));
      }
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


  @override
  Future<Either<ApiFailure, Response>> getBudgetForComplain({
    required String complainID
  }) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final agencyID = prefs.getString('agencyID');
      final tenantID = prefs.getString('tenantID');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final response = await sl<DioClient>().get(
        ApiUrls.getBudget,
        queryParameters: {
          'AgencyID': agencyID,
          'ComplainID': complainID,
          'tenantID' : tenantID
        },
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
  Future<Either<ApiFailure, Response>> editComplain(ComplainEditPostParams model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final formData = await model.toFormData();

      print('Sending to ${ApiUrls.editComplain}');
      print('Headers: Authorization: Bearer $token');
      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files.map((e) => e.key + ' -> ' + (e.value.filename ?? ''))}');

      final response = await sl<DioClient>().post(
        ApiUrls.editComplain, // Make sure to add this endpoint to your ApiUrls class
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

  @override
  Future<Either<ApiFailure, Response>> reComplain(ReComplainParams model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final formData = await model.toFormData();

      print('Sending to ${ApiUrls.reComplain}');
      print('Headers: Authorization: Bearer $token');
      print('FormData fields: ${formData.fields}');
      print('FormData files: ${formData.files.map((e) => e.key + ' -> ' + (e.value.filename ?? ''))}');

      final response = await sl<DioClient>().post(
        ApiUrls.reComplain,
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



  @override
  Future<Either<ApiFailure, Response>> markAsCompleted(ComplainCompletedRequest model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      // Convert model to JSON
      final requestData = model.toJson();

      print('Sending to ${ApiUrls.markComplainCompleted}');
      print('Headers: Authorization: Bearer $token');
      print('Request data: $requestData');

      final response = await sl<DioClient>().post(
        ApiUrls.markComplainCompleted, // Make sure to add this endpoint to your ApiUrls class
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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

  @override
  Future<Either<ApiFailure, Response>> postAcceptBudget(BudgetPostModel model, bool isReview) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      String url = '';

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      // Convert model to JSON
      final requestData = model.toJson();

      if(isReview){
        url = ApiUrls.reviewBudget;
      }else{
        url = ApiUrls.acceptBudget;
      }

      print('Sending to ${ApiUrls.acceptBudget}');
      print('Headers: Authorization: Bearer $token');
      print('Request data: $requestData');

      final response = await sl<DioClient>().post(
        url, // conditional url
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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

  @override
  Future<Either<ApiFailure, Response>> approveComplaints(ComplainApprovalRequestModel model) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      // Convert model to JSON
      final requestData = model.toJson();

      print('Sending to ${ApiUrls.approveComplaints}'); // Add this URL to your ApiUrls
      print('Headers: Authorization: Bearer $token');
      print('Request data: $requestData');

      final response = await sl<DioClient>().post(
        ApiUrls.approveComplaints,
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
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


  @override
  Future<Either<ApiFailure, Response>> getAgencyInfo(String agencyID) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final response = await sl<DioClient>().get(
        ApiUrls.getAgencyInfo,
        queryParameters: {
          'AgencyId': agencyID,
        },
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



}
