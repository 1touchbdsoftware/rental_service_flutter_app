import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rental_service/domain/usecases/is_loggedin_usecase.dart';

import '../../../service_locator.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit() : super(AuthInitialState());

  void appStarted() async{
    var isLoggedIn = await sl<IsLoggedinUsecase>().call();

    if(isLoggedIn) {
      emit(Authenticated());

    }else{
      emit(UnAuthenticated());
    }
  }

}
