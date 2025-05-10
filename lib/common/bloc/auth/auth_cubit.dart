import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rental_service/domain/usecases/is_loggedin_usecase.dart';
import 'package:rental_service/domain/usecases/logout_usecase.dart';

import '../../../service_locator.dart';

part 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  void appStarted() async {
    var isLoggedIn = await sl<IsLoggedinUsecase>().call();
    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }

  Future<void> logOut({required LogoutUseCase usecase}) async {
    try {
      final result = await usecase.call();
      result.fold(
            (failure) => emit(AuthErrorState(message: "Logout failed")),
            (success) => emit(UnAuthenticated()),
      );
    } catch (e) {
      emit(AuthErrorState(message: "Logout error: $e"));
    }
  }
}