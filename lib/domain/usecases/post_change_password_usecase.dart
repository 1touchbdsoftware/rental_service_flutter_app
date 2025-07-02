import 'package:dartz/dartz.dart';
import 'package:rental_service/data/model/password/change_password_request.dart';
import 'package:rental_service/domain/repository/auth.dart';

import '../../core/usecase/usecase.dart';
import '../../service_locator.dart';

class ChangePasswordUseCase implements UseCase<Either<String, bool>, ChangePasswordRequest> {
  @override
  Future<Either<String, bool>> call({ChangePasswordRequest? param}) async {
    if (param == null) {
      return Left('Password change parameters cannot be null');
    }
    return sl<AuthRepository>().changePassword(param);
  }
}