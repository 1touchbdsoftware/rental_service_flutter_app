import 'package:dartz/dartz.dart';
import 'package:rental_service/core/usecase/usecase.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../data/model/complain_response_model.dart';
import '../../service_locator.dart';



// 5. Update the use case to handle nullable String

class GetTenantComplainsUseCase implements UseCase<Either, GetComplainsParams> {



  @override
  Future<Either> call({
    GetComplainsParams? param,
  }) async {
    try {
      print("UseCase: Validating parameters");
      if (param == null) {
        print("UseCase: Parameters are null");
        return const Left('Parameters cannot be null');
      }

      print("UseCase: Calling repository");
      final result = sl<ComplainsRepository>().getTenantComplains(param);
      print("UseCase: Repository result received");

      return result;
    } catch (e) {
      print("UseCase: Exception caught: $e");
      return Left(e.toString());
    }
  }
}

