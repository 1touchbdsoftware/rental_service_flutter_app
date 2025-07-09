import 'package:dartz/dartz.dart';
import 'package:rental_service/domain/repository/auth.dart';

import '../../core/usecase/usecase.dart';
import '../../service_locator.dart';

class ForgotPasswordUseCase implements UseCase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('Email cannot be null or empty');
    }
    return sl<AuthRepository>().forgotPassword(param);
  }
}
