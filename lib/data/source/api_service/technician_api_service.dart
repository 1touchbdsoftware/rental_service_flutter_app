import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../../model/api_failure.dart';
import '../../model/technician/post_accept_technician_params.dart';
import '../../model/technician/technician_get_params.dart';

abstract class TechnicianApiService {
  Future<Either<ApiFailure, Response>> getAssignedTechnician(TechnicianRequestParams params);
  Future<Either<ApiFailure, Response>> acceptTechnician(AcceptTechnicianParams params);
}

class TechnicianApiServiceImpl implements TechnicianApiService {
  TechnicianApiServiceImpl();

  @override
  Future<Either<ApiFailure, Response>> getAssignedTechnician(TechnicianRequestParams params) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');
      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final queryParams = {
        'TechnicianAssignID': params.technicianAssignID ?? '',
        'AgencyID': params.agencyID,
        'ComplainID': params.complainID,
        'TenantID': params.tenantID,
        'TechnicianID': params.technicianID,
        'PropertyID': params.propertyID,
        // You can add 'StateStatus' if needed
      };

      final response = await sl<DioClient>().get(
        ApiUrls.getAssignedTechnician,
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
  Future<Either<ApiFailure, Response>> acceptTechnician(AcceptTechnicianParams params) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');
      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      // Convert params to JSON for POST request body
      final requestBody = params.toJson();

      // Make POST request to accept technician endpoint
      // Note: You may need to update ApiUrls with the correct endpoint
      final response = await sl<DioClient>().post(
        ApiUrls.acceptAssignedTechnician, // Update this with the correct endpoint
        data: requestBody,
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
}