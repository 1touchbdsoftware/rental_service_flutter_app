
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/technician_repository.dart';
import '../../service_locator.dart';
import '../model/api_failure.dart';
import '../model/technician/technician_get_params.dart';
import '../model/technician/technician_response_model.dart';
import '../source/api_service/get_assigned_technician_api_service.dart';

class TechnicianRepositoryImpl extends TechnicianRepository {
  @override
  Future<Either<String, TechnicianResponse>> getAssignedTechnician(TechnicianRequestParams params) async {
    Either<ApiFailure, Response> result =
    await sl<TechnicianApiService>().getAssignedTechnician(params);

    return result.fold(
          (error) {
        return Left(error.message);
      },
          (data) {
        try {
          final responseModel = TechnicianResponse.fromJson(data.data);
          return Right(responseModel);
        } catch (e) {
          return Left('Failed to parse response: ${e.toString()}');
        }
      },
    );
  }
}


