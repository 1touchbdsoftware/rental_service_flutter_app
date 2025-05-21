class UserInfoEntity {
  final String id;
  final String userName;
  final String agencyID;
  final bool isActive;
  final String? landlordID;        // Make nullable
  final String? landlordName;      // Make nullable
  final String? tenantID;          // Add as nullable
  final String? tenantName;        // Add as nullable
  final String? propertyID;        // Add as nullable
  final String? tenantInfoID;      // Add as nullable
  final String registrationType;
  final String contactNumber;
  final String emailAddress;
  final String? propertyName;

  const UserInfoEntity({
    required this.id,
    required this.userName,
    required this.agencyID,
    required this.isActive,
    this.landlordID,
    this.landlordName,
    this.tenantID,
    this.tenantName,
    this.propertyID,
    this.tenantInfoID,
    this.propertyName,
    required this.registrationType,
    required this.contactNumber,
    required this.emailAddress,
  });
}