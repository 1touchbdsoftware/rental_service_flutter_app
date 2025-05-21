import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';

import '../../../domain/repository/user_repository.dart';
import '../../../service_locator.dart';

class UserInfoCubit extends Cubit<UserInfoModel> {
  UserInfoCubit(super.initialState);


  Future<void> loadUserInfo() async {
    UserInfoModel userInfo = await sl<UserRepository>().getSavedUserInfo();

    emit(userInfo); // Update state with the fetched username
  }
}