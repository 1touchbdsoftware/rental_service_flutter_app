import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_urls.dart';
import '../../core/network/dio_client.dart';

import '../../service_locator.dart';
import '../model/complain_response_model.dart';
import '../model/get_complain_req_params.dart';

abstract class ComplainApiService {
  // Change type to accept nullable String to match implementation
  Future<Either> getComplains(GetComplainsParams params);
}

// 1. First, let's fix the ComplainApiServiceImpl class:
class ComplainApiServiceImpl implements ComplainApiService {
  ComplainApiServiceImpl();

  @override
  Future<Either> getComplains(
      GetComplainsParams params
      ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get token from SharedPreferences
      final token = prefs.getString('token');
      if (token == null) {
        return const Left('Authentication token not found');
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


      print(response.data);

      return Right(response);
    } on DioException catch (e) {
      // Ensure we never return null as error - use empty string if needed
      final errorMsg = e.response?.data?['message']?.toString()
          ?? e.message
          ?? 'Request failed with status ${e.response?.statusCode ?? "unknown"}';
      return Left(errorMsg);
    } catch (e) {
      // Always return a non-null string
      return Left(e.toString());
    }
  }
}
