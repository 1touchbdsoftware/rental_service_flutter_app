import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {


  UserRepositoryImpl();

  @override
  Future<String?> getSavedUsername() async {
    // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // return sharedPreferences.getString('userName');
  }

  @override
  Future<String?> getUserType() async {
    // final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // return sharedPreferences.getString('userType');
  }


}