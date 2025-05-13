


import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/get_segment_params.dart';
import 'package:rental_service/data/model/segment_response_model.dart';
import 'package:rental_service/data/source/get_segment_api_service.dart';
import 'package:rental_service/domain/repository/segment_repository.dart';

import '../../service_locator.dart';
import '../model/api_failure.dart';

class SegmentRepositoryImpl extends SegmentRepository{


  @override
  Future<Either<String, SegmentResponseModel>>
  getSegmentList(GetSegmentParams params) async {

    Either<ApiFailure, Response> result =
        await sl<SegmentApiService>().getSegments(params);

    return result.fold(
            (error) {
          return Left(error.message);
        },
            (data) {
          try {
            final responseModel = SegmentResponseModel.fromJson(data.data);
            return Right(responseModel);
          } catch (e) {
            return Left('Failed to parse response: ${e.toString()}');
          }
        }
    );
  }


}