import 'package:dartz/dartz.dart';
import 'package:rental_service/core/usecase/usecase.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../data/model/complain/complain_response_model.dart';
import '../../service_locator.dart';


class GetTenantComplainsUseCase implements UseCase<Either<String, ComplainResponseModel>, GetComplainsParams> {
  @override
  Future<Either<String, ComplainResponseModel>> call({
    GetComplainsParams? param,
  }) async {
    try {
      if (param == null) {
        return const Left('Parameters cannot be null');
      }

      // Directly return the result from repository - don't wrap in another try/catch
      return await sl<ComplainsRepository>().getTenantComplains(param);
    } catch (e) {
      print("USECASE: CATCH CALLED");
      // This catch block should only handle exceptions from the service locator
      return Left(e.toString());
    }
  }
}


