import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rental_service/domain/usecases/get_user_type_usecase.dart';

import '../../../service_locator.dart';

part 'user_type_state.dart';

class UserTypeCubit extends Cubit<UserTypeState> {
  UserTypeCubit() : super(UserTypeInitialState());

  //this will emit the new states or changed data

  Future<void> getUserType() async {
    emit(UserTypeLoadingState()); // Add a loading state

    try {
      var userType = await sl<GetUserTypeUseCase>().call();

      if (userType == "LANDLORD") {
        emit(UserTypeLandLord());
      } else if (userType == "TENANT") {
        emit(UserTypeTenant());
      } else if (userType == "TECHNICIAN") {
        emit(UserTypeTechnician());
      }
      else {
        emit(UserTypeError(message: "Unknown user type: $userType"));
      }
    } catch (e) {
      emit(UserTypeError(message: "Failed to get user type: $e"));
    }
  }

}
