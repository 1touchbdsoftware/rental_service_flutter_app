

import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';

import '../../data/model/complain/complain_req_params/complain_edit_post.dart';
import '../../domain/repository/complains_repository.dart';
import '../../service_locator.dart';

class EditComplainUseCase implements UseCase<Either<String, bool>, ComplainEditPostParams> {
  @override
  Future<Either<String, bool>> call({ComplainEditPostParams? param}) async {
    if (param == null) {
      return Left('Edit complain parameters cannot be null');
    }

    return sl<ComplainsRepository>().editComplain(param);
  }
}