class UserInfoEntity {
  final String id;
  final String userName;
  final String agencyID;
  final bool isActive;
  final String landlordID;
  final String landlordName;
  final String registrationType;
  final String contactNumber;
  final String emailAddress;

  const UserInfoEntity({
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
}
