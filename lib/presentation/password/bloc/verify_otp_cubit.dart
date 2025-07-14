// verify_otp_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/post_otp_verification.dart';
import 'verify_otp_state.dart'; // You'll need to define the states for the VerifyOtpCubit

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  VerifyOtpCubit() : super(VerifyOtpInitial());

  Future<void> verifyOtp(String otp) async {
    try {
      emit(VerifyOtpLoading());
print("cubit - verify called");

      // Call the VerifyOtpUseCase
      final result = await VerifyOtpUseCase().call(param: otp);

      result.fold(
            (errorMessage) {
          emit(VerifyOtpFailure(errorMessage));
        },
            (success) {
          emit(VerifyOtpSuccess(success));
        },
      );
    } catch (e) {
      emit(VerifyOtpFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
