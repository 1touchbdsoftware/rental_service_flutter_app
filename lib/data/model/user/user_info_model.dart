import '../../../domain/entities/user_info_entity.dart';

class UserInfoModel extends UserInfoEntity {
  UserInfoModel({
    required String id,
    required String userName,
    required String agencyID,
    required bool isActive,
    String? landlordID,
    String? landlordName,
    String? tenantID,
    String? tenantName,
    String? propertyID,
    String? propertyName,
    String? tenantInfoID,
    required String registrationType,
    required String contactNumber,
    required String emailAddress,
    required String userType,
    required bool isDefaultPassword,
  }) : super(
    id: id,
    userName: userName,
    agencyID: agencyID,
    isActive: isActive,
    landlordID: landlordID,
    landlordName: landlordName,
    tenantID: tenantID,
    tenantName: tenantName,
    propertyID: propertyID,
    tenantInfoID: tenantInfoID,
    registrationType: registrationType,
    contactNumber: contactNumber,
    emailAddress: emailAddress,
    propertyName: propertyName,
    userType: userType,
    isDefaultPassword: isDefaultPassword,
  );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      userName: json['userName'],
      agencyID: json['agencyID'],
      isActive: json['isActive'],
      landlordID: json['landlordID'],
      landlordName: json['employeeName'],
      tenantID: json['employeeId'],
      tenantName: json['employeeName'],
      propertyID: json['propertyID'],
      tenantInfoID: json['tenantInfoID'],
      registrationType: json['registrationType'],
      contactNumber: json['contactNumber'],
      emailAddress: json['email'],
      propertyName: json['propertyName'],
      userType: json['registrationType'],
      isDefaultPassword: json['isDefaultPassword'],
    );
  }

  factory UserInfoModel.empty() => UserInfoModel(
    id: '',
    userName: 'Loading...',
    agencyID: '',
    isActive: false, registrationType: '', contactNumber: '', emailAddress: '', userType: '', isDefaultPassword: true,
    // ... other empty fields
  );
}