
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/technician_repository.dart';
import '../../service_locator.dart';
import '../model/api_failure.dart';
import '../model/technician/post_accept_technician_params.dart';
import '../model/technician/post_reschedule_technician_params.dart';
import '../model/technician/technician_get_params.dart';
import '../model/technician/technician_response_model.dart';
import '../source/api_service/technician_api_service.dart';

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

  @override
  Future<Either<String, bool>> acceptTechnician(AcceptTechnicianParams params) async {
    final result =
    await sl<TechnicianApiService>().acceptTechnician(params);

    return result.fold(
          (error) {
        return Left(error.message);
      },
          (response) {
        try {
          final success = response.statusCode == 200 || response.statusCode == 201;
          return Right(success);
        } catch (e) {
          return Left('Failed to parse response: ${e.toString()}');
        }
      },
    );
  }

  @override
  Future<Either<String, bool>> rescheduleTechnician(TechnicianRescheduleParams params) async {
    Either<ApiFailure, Response> result =
    await sl<TechnicianApiService>().rescheduleTechnician(params);

    return result.fold(
          (error) {
        return Left(error.message);
      }, (response) {
        try {
          final success = response.statusCode == 200 || response.statusCode == 201;
          return Right(success);
        } catch (e) {
          return Left('Failed to parse response: ${e.toString()}');
        }
      },
    );
  }
}


