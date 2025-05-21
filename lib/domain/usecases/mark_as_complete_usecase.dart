import 'package:dartz/dartz.dart';
import '../../core/usecase/usecase.dart';

import '../../data/model/complain/complain_req_params/completed_post_req.dart';
import '../../domain/repository/complains_repository.dart';
import '../../service_locator.dart';

class MarkComplainCompletedUseCase implements UseCase<Either<String, bool>, ComplainCompletedRequest> {
  @override
  Future<Either<String, bool>> call({ComplainCompletedRequest? param}) async {
    if (param == null) {
      return Left('ComplainCompleted parameters cannot be null');
    }

    return sl<ComplainsRepository>().markComplainAsCompleted(param);
  }
}