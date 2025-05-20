import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/complain/complain_req_params/get_complain_req_params.dart';
import 'package:rental_service/data/source/api_service/complains_api_service.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../domain/entities/complain_response_entity.dart';
import '../../service_locator.dart';
import '../model/api_failure.dart';
import '../model/complain/complain_req_params/complain_edit_post_params.dart';
import '../model/complain/complain_req_params/complain_post_req_params.dart';
import '../model/complain/complain_response_model.dart';

class ComplainsRepositoryImpl implements ComplainsRepository {

  // FETCH RESPONSE THEN FILTER
  @override
  Future<Either<String, ComplainResponseModel>> getTenantComplains(
      GetComplainsParams params,
      ) async {
    Either<ApiFailure, Response> result =
    await sl<ComplainApiService>().getComplains(params);

    print('REPO: GET COMPLAINS PARAM: ${params.tab} PAGE: ${params.pageNumber} ');

    print("REPO: COMPLAINS CALLED");
    return result.fold(
          (error) => Left(error.message),
          (data) {
        try {
          final responseModel = ComplainResponseModel.fromJson(data.data);
          return Right(responseModel);
        } catch (e) {
          return Left('Failed to parse response: ${e.toString()}');
        }
      },
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


  @override
  Future<Either<String, bool>> editComplain(ComplainEditPostParams model) async {
    Either<ApiFailure, Response> result =
    await sl<ComplainApiService>().editComplain(model);

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
