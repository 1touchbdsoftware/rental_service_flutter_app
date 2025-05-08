import 'package:dartz/dartz.dart';
import 'package:rental_service/core/usecase/usecase.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';

import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../data/model/complain_response_model.dart';
import '../../service_locator.dart';

class GetTenantComplainsUseCase implements UseCase<Either<String, ComplainResponseModel>, GetComplainsParams> {

  @override
  Future<Either<String, ComplainResponseModel>> call({GetComplainsParams? param}) async {

    print("USECASE BEING CALLED");
    final repo = sl<ComplainsRepository>();

    final result = await repo.getTenantComplains(param!);

    if (result == null) {
      print("Failed to fetch complaints");
    }

    return result;
  }
}
