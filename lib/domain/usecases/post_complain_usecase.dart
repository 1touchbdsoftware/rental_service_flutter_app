

import 'package:dartz/dartz.dart';
import 'package:rental_service/data/model/complain/complain_req_params/complain_post_req_params.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';

import '../../core/usecase/usecase.dart';
import '../../service_locator.dart';

class LogoutUseCase implements UseCase<Either, ComplainPostModel>{

  @override
  Future<Either> call({ComplainPostModel? param}) async {

    return sl<ComplainsRepository>().saveComplain(param!);
  }


}