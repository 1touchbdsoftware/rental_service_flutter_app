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
    String? tenantInfoID,
    required String registrationType,
    required String contactNumber,
    required String emailAddress,
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
  );

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      userName: json['userName'],
      agencyID: json['agencyID'],
      isActive: json['isActive'],
      landlordID: json['landlordID'],
      landlordName: json['landlordName'],
      tenantID: json['tenantID'],
      tenantName: json['tenantName'],
      propertyID: json['propertyID'],
      tenantInfoID: json['tenantInfoID'],
      registrationType: json['registrationType'],
      contactNumber: json['contactNumber'],
      emailAddress: json['emailAddress'],
    );
  }
}