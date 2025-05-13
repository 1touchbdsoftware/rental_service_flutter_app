import 'package:rental_service/data/source/get_user_local_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/user_repository.dart';
import '../../service_locator.dart';

class UserRepositoryImpl implements UserRepository {


  UserRepositoryImpl();

  @override
  Future<String?> getSavedUsername() async {

    print("USER REPO: GET USERNAME CALLED");
    // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sl<GetUserLocalService>().getSavedUsername();
  }

  @override
  Future<String> getUserType() async {
    print("USER REPO: GET USER TYPE CALLED");
    // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // return sharedPreferences.getString('userType');

    return await sl<GetUserLocalService>().getUserType();
  }


}