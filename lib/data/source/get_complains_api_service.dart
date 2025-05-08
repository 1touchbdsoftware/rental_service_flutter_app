import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_urls.dart';
import '../../core/network/dio_client.dart';

import '../../service_locator.dart';
import '../model/complain_response_model.dart';
import '../model/get_complain_req_params.dart';

abstract class ComplainApiService {
  Future<Either<String, ComplainResponseModel>> getComplains(GetComplainsParams params);
}

class ComplainApiServiceImpl implements ComplainApiService {

  ComplainApiServiceImpl();

  @override
  Future<Either<String, ComplainResponseModel>> getComplains(
      GetComplainsParams params,
      ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      // Get token from SharedPreferences
      final token = prefs.getString('token');
      if (token == null) {
        return Left('Authentication token not found');
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

      final complainResponse = ComplainResponseModel.fromJson(response.data);
      return Right(complainResponse);
    } on DioException catch (e) {
      return Left(e.response?.data['message'] ?? 'Something went wrong');
    } catch (e) {
      return Left(e.toString());
    }
  }
}