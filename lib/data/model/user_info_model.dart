import '../../domain/entities/user_info_entity.dart';

class UserInfo extends UserInfoEntity {
  UserInfo({
    required String id,
    required String userName,
    required String agencyID,
    required bool isActive,
    required String landlordID,
    required String landlordName,
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
    registrationType: registrationType,
    contactNumber: contactNumber,
    emailAddress: emailAddress,
  );

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      userName: json['userName'],
      agencyID: json['agencyID'],
      isActive: json['isActive'],
      landlordID: json['landlordID'],
      landlordName: json['landlordName'],
      registrationType: json['registrationType'],
      contactNumber: json['contactNumber'],
      emailAddress: json['emailAddress'],
    );
  }
}
