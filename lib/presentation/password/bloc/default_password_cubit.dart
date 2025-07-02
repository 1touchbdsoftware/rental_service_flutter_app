// default_password_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/domain/repository/user_repository.dart';
import 'default_password_state.dart';
import '../../../service_locator.dart';

class DefaultPasswordCubit extends Cubit<DefaultPasswordState> {

  DefaultPasswordCubit() : super(DefaultPasswordInitial());

  Future<void> checkIfDefaultPassword() async {
    try {
      emit(DefaultPasswordLoading());

      // Call the repository method to check if the password is the default one
      final bool isDefaultPassword = await sl<UserRepository>().isDefaultPassword();

      if (isDefaultPassword) {
        emit(IsDefaultPasswordState(isDefaultPassword));
      } else {
        emit(NotDefaultPasswordState(isDefaultPassword));
      }
    } catch (e) {
      emit(DefaultPasswordFailure('Failed to check if the password is default.'));
    }
  }
}
