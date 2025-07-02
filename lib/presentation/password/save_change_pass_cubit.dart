import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/password/change_password_request.dart';
import 'package:rental_service/service_locator.dart';
import '../../common/bloc/button/button_state.dart';
import '../../domain/usecases/post_change_password_usecase.dart';

class ChangePasswordCubit extends Cubit<ButtonState> {
  final ChangePasswordUseCase _changePasswordUseCase;

  ChangePasswordCubit({ChangePasswordUseCase? useCase})
    : _changePasswordUseCase = useCase ?? sl<ChangePasswordUseCase>(),
      super(ButtonInitialState());

  Future<void> changePassword(ChangePasswordRequest model) async {
    emit(ButtonLoadingState());

    try {
      final result = await _changePasswordUseCase.call(param: model);

      result.fold(
        (failure) {
          print("ChangePasswordCubit error: $failure");
          emit(ButtonFailureState(errorMessage: failure));
        },
        (success) {
          if (success) {
            emit(ButtonSuccessState());
          } else {
            emit(
              ButtonFailureState(
                errorMessage: "Password change failed unexpectedly",
              ),
            );
          }
        },
      );
    } catch (e) {
      emit(
        ButtonFailureState(errorMessage: 'Unexpected error: ${e.toString()}'),
      );
    }
  }
}
