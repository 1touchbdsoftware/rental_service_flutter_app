import 'package:rental_service/data/model/user/user_info_model.dart';
import 'package:rental_service/data/source/local_service/get_user_local_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/user_repository.dart';
import '../../service_locator.dart';

class UserRepositoryImpl implements UserRepository {

  UserRepositoryImpl();

  @override
  Future<UserInfoModel> getSavedUserInfo() async {
    print("USER REPO: USER INFO CALLED");
    return await sl<GetUserLocalService>().getSavedUserInfo();
  }

  @override
  Future<String> getUserType() async {
    print("USER REPO: GET USER TYPE CALLED");
    return await sl<GetUserLocalService>().getUserType();
  }


  @override
  Future<bool> isDefaultPassword() async {
    print("USER REPO: Default Password Check");

    return await sl<GetUserLocalService>().isDefaultPassword();
  }



}