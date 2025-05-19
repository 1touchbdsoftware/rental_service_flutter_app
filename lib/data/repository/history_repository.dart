import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repository/history_repository.dart';
import '../../service_locator.dart';
import '../model/api_failure.dart';
import '../model/history/history_query_params.dart';
import '../model/history/history_response_model.dart';
import '../source/api_service/get_history_api_service.dart';


class HistoryRepositoryImpl extends HistoryRepository {
  @override
  Future<Either<String, HistoryResponseModel>> getHistory(HistoryQueryParams params) async {
    Either<ApiFailure, Response> result =
    await sl<HistoryApiService>().getHistory(params);

    return result.fold(
          (error) {
        return Left(error.message);
      },
          (data) {
        try {
          final responseModel = HistoryResponseModel.fromJson(data.data);
          return Right(responseModel);
        } catch (e) {
          return Left('Failed to parse response: ${e.toString()}');
        }
      },
    );
  }
}
