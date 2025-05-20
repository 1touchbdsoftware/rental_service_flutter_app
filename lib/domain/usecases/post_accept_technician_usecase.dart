


import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../../data/model/technician/post_accept_technician_params.dart';
import '../../data/model/technician/technician_response_model.dart';
import '../../service_locator.dart';
import '../repository/technician_repository.dart';

class AcceptTechnicianUseCase implements UseCase<Either, AcceptTechnicianParams> {
  @override
  Future<Either> call({AcceptTechnicianParams? param}) async {
    if (param == null) {
      return Left('Accept technician parameters cannot be null');
    }

    return sl<TechnicianRepository>().acceptTechnician(param);
  }
}