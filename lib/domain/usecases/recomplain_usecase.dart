import 'package:dartz/dartz.dart';
import '../../core/usecase/usecase.dart';

import '../../data/model/complain/complain_req_params/recomplain_post_req.dart';
import '../../domain/repository/complains_repository.dart';
import '../../service_locator.dart';

class ReComplainUseCase implements UseCase<Either<String, bool>, ReComplainParams> {


  @override
  Future<Either<String, bool>> call({ReComplainParams? param}) async {
    if (param == null) {
      return Left('ReComplain parameters cannot be null');
    }

    return sl<ComplainsRepository>().reComplain(param);
  }
}