import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../../model/api_failure.dart';
import '../../model/history/history_query_params.dart'; // adjust path

abstract class HistoryApiService {
  Future<Either<ApiFailure, Response>> getHistory(HistoryQueryParams params);
}

class HistoryApiServiceImpl implements HistoryApiService {
  HistoryApiServiceImpl();

  @override
  Future<Either<ApiFailure, Response>> getHistory(HistoryQueryParams params) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final queryParams = {
        'AgencyID': params.agencyID,
        'ComplainID': params.complainID,
      };

      final response = await sl<DioClient>().get(
        ApiUrls.getHistory,
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
}
