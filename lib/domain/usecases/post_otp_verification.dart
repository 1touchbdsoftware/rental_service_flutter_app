import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../../service_locator.dart';
import '../repository/auth.dart';

class VerifyOtpUseCase implements UseCase<Either<String, bool>, String> {
  @override
  Future<Either<String, bool>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('OTP cannot be null or empty');
    }

    // Call the repository method to verify the OTP
    return sl<AuthRepository>().verifyOtp(param);
  }
}
