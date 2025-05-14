import 'package:rental_service/data/model/user/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GetUserLocalService{

  Future<String> getUserType();
  Future<UserInfoModel> getSavedUserInfo();

}

class GetUserLocalServiceImpl extends GetUserLocalService{
  @override
  Future<UserInfoModel> getSavedUserInfo() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return UserInfoModel(
      id: sharedPreferences.getString('id') ?? '',
      userName: sharedPreferences.getString('userName') ?? '',
      agencyID: sharedPreferences.getString('agencyID') ?? '',
      isActive: true, // Assuming always true; if you store this, retrieve it properly
      landlordID: sharedPreferences.getString('landlordID') ?? '',
      landlordName: sharedPreferences.getString('landlordName') ?? '',
      tenantID: sharedPreferences.getString('tenantID') ?? '',
      tenantName: sharedPreferences.getString('tenantName') ?? '',
      propertyID: sharedPreferences.getString('propertyID'),
      tenantInfoID: sharedPreferences.getString('tenantInfoID') ?? '',
      registrationType: sharedPreferences.getString('registrationType') ?? '',
      contactNumber: sharedPreferences.getString('contactNumber') ?? '',
      emailAddress: sharedPreferences.getString('emailAddress') ?? '',
    );
  }

  @override
  Future<String> getUserType() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString('userType')!;
  }

}