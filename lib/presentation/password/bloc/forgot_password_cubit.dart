// forgot_password_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/post_forgot_pass_req.dart';
import 'forgot_request_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> requestPasswordReset(String email) async {
    try {
      emit(ForgotPasswordLoading());

      // Call the ForgotPasswordUseCase
      final result = await ForgotPasswordUseCase().call(param: email);

      result.fold(
            (errorMessage) {
          emit(ForgotPasswordFailure(errorMessage));
        },
            (success) {
          emit(ForgotPasswordSuccess(success));
        },
      );
    } catch (e) {
      emit(ForgotPasswordFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }
}
