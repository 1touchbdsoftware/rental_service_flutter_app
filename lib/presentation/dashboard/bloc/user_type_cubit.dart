import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'user_type_state.dart';

class UserTypeCubit extends Cubit<UserTypeState> {
  UserTypeCubit() : super(UserTypeInitialState());

  //this will emit the new states or changed data

void getUserType() async {

}
}
