

import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../../data/model/technician/technician_get_params.dart';
import '../../data/model/technician/technician_response_model.dart';
import '../../service_locator.dart';
import '../repository/technician_repository.dart';

class GetAssignedTechnicianUseCase
    implements UseCase<Either<String, TechnicianResponse>, TechnicianRequestParams> {

  @override
  Future<Either<String, TechnicianResponse>> call({
    TechnicianRequestParams? param,
  }) async {
    try {
      if (param == null) {
        return const Left('Parameters cannot be null');
      }

      return await sl<TechnicianRepository>().getAssignedTechnician(param);
    } catch (e) {
      return Left(e.toString());
    }
  }
}

