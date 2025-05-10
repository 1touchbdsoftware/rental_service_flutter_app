import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/data/source/get_complains_api_service.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../service_locator.dart';
import '../model/complain_response_model.dart';


class ComplainsRepositoryImpl extends ComplainsRepository {



  @override
  Future<Either<String, ComplainResponseModel>> getTenantComplains(
      GetComplainsParams params,
      ) async {
    Either result = await sl<ComplainApiService>().getComplains(params);

    print("COMPLAIN REPO:");


    return result.fold(
        (error) {
          print("REPOSITORY: ERROR CALLED");
          return Left(error);
        },
        (data) async {
          print("REPOSITORY: RIGHT CALLED");

          Response response = data;

          final responseModel = ComplainResponseModel.fromJson(response.data);

          return Right(responseModel);
        }
    );
    // try {
    //   print("Repository: Getting complains from API");
    //
    //   print("Repository: API result received, type: ${result.runtimeType}");
    //
    //   // Simply pass through the result - don't manipulate the Either here
    //   return result;
    // } catch (e) {
    //   print("Repository: Exception caught: $e");
    //   return Left(e.toString());
    // }
  }
}
