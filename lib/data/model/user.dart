class UserModel {
  final int statusCode;
  final String message;
  final String token;
  final UserInfo userInfo;

  UserModel({
    required this.statusCode,
    required this.message,
    required this.token,
    required this.userInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      statusCode: json['statusCode'],
      message: json['message'],
      token: json['data']['token'],
      userInfo: UserInfo.fromJson(json['data']['userInfo']),
    );
  }
}

class UserInfo {
  final String id;
  final String userName;
  final String agencyID;
  final bool isActive;
  final String landlordID;
  final String landlordName;
  final String registrationType;
  final String contactNumber;
  final String emailAddress;

  UserInfo({
    required this.id,
    required this.userName,
    required this.agencyID,
    required this.isActive,
    required this.landlordID,
    required this.landlordName,
    required this.registrationType,
    required this.contactNumber,
    required this.emailAddress,
  });

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
