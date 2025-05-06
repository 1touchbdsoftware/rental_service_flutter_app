


import 'package:shared_preferences/shared_preferences.dart';

abstract class GetUserLocalService{

  Future<String?> getUserType();
  Future<String?> getSavedUsername();



}

class GetUserLocalServiceImpl extends GetUserLocalService{
  @override
  Future<String?> getSavedUsername() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userName');
  }

  @override
  Future<String?> getUserType() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userType');
  }

}