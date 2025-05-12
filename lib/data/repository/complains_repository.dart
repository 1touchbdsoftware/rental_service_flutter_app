import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/data/source/get_complains_api_service.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../service_locator.dart';
import '../model/complain_response_model.dart';


class ComplainsRepositoryImpl implements ComplainsRepository {
  @override
  Future<Either<String, ComplainResponseModel>> getTenantComplains(
      GetComplainsParams params,
      ) async {
    Either<ApiFailure, Response> result = await sl<ComplainApiService>().getComplains(params);

    return result.fold(
            (error) {
          return Left(error.message);
        },
            (data) {
          try {
            final responseModel = ComplainResponseModel.fromJson(data.data);
            return Right(responseModel);
          } catch (e) {
            return Left('Failed to parse response: ${e.toString()}');
          }
        }
    );
  }
}
