import 'package:rental_service/data/model/user/user_info_model.dart';

abstract class UserRepository {
  Future<UserInfoModel> getSavedUserInfo(); // just the interface

  Future<String> getUserType();
// ... other methods (login, etc.)
}