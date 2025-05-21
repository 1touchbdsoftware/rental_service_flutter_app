

import 'package:dartz/dartz.dart';
import 'package:rental_service/core/usecase/usecase.dart';
import 'package:rental_service/data/model/user/signin_req_params.dart';
import 'package:rental_service/domain/repository/auth.dart';

import '../../service_locator.dart';

class SigninUseCase implements UseCase<Either<String, bool>, SignInReqParams>{

  @override
  Future<Either<String, bool>> call({SignInReqParams? param}) async {

    return sl<AuthRepository>().signin(param!);
  }


}