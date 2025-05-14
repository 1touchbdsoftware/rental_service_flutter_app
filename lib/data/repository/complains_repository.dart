import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/data/source/complains_api_service.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../service_locator.dart';
import '../model/api_failure.dart';
import '../model/complain/complain_req_params/complain_post_req_params.dart';
import '../model/complain/complain_response_model.dart';


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


  ///New method: Save complain
  @override
  Future<Either<String, bool>> saveComplain(ComplainPostModel model) async {
    final result = await sl<ComplainApiService>().saveComplain(model);

    return result.fold(
          (error) => Left(error.message),
          (response) {
        try {
          // You can adjust based on what your API returns.
          final success = response.statusCode == 200 || response.statusCode == 201;
          return Right(success);
        } catch (e) {
          return Left('Failed to save complain: ${e.toString()}');
        }
      },
    );
  }
}
