// verify_otp_state.dart
abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpFailure extends VerifyOtpState {
  final String errorMessage;
  VerifyOtpFailure(this.errorMessage);
}

class VerifyOtpSuccess extends VerifyOtpState {
  final bool success;
  VerifyOtpSuccess(this.success);
}
