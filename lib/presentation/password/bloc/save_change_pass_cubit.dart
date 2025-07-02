import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/password/change_password_request.dart';
import 'package:rental_service/presentation/password/bloc/save_change_pass_state.dart';
import 'package:rental_service/service_locator.dart';
import '../../../domain/usecases/post_change_password_usecase.dart';
// Import the new state

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit({ChangePasswordUseCase? useCase})
      : _changePasswordUseCase = useCase ?? sl<ChangePasswordUseCase>(),
        super(const ChangePasswordInitial());

  Future<void> changePassword(ChangePasswordRequest model) async {
    emit(const ChangePasswordLoading());

    try {
      final result = await _changePasswordUseCase.call(param: model);

      result.fold(
            (failure) {
          print("ChangePasswordCubit error: $failure");
          emit(ChangePasswordFailure(failure));
        },
            (success) {
          if (success) {
            emit(const ChangePasswordSuccess("Password changed successfully!"));
          } else {
            emit(const ChangePasswordFailure(
                "Password change failed unexpectedly"
            ));
          }
        },
      );
    } catch (e) {
      emit(ChangePasswordFailure('Unexpected error: ${e.toString()}'));
    }
  }
}