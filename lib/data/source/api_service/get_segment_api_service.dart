

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/get_segment_params.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/api_urls.dart';
import '../../../core/network/dio_client.dart';
import '../../../service_locator.dart';
import '../../model/api_failure.dart';

abstract class SegmentApiService {
  Future<Either<ApiFailure, Response>> getSegments(GetSegmentParams params);
}

class SegmentApiServiceImpl implements SegmentApiService {
  SegmentApiServiceImpl();

  @override
  Future<Either<ApiFailure, Response>> getSegments(
      GetSegmentParams params
      ) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final token = prefs.getString('token');
      if (token == null) {
        return Left(ApiFailure('Authentication token not found'));
      }

      final queryParams = {
        'agencyID': params.agencyID,
        'landlordID' : params.landlordID,
        'propertyID' : params.propertyID,
        'segmentID' : params.segmentID ?? '',
      };

      final response = await sl<DioClient>().get(
        ApiUrls.propertyWiseSegment,
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
