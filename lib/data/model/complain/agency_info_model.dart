class AgencyInfoModel {
  final String agencyID;
  final String name;
  final String agencyName;
  final String emailAddress;
  final String contactNumber;
  final String? fullLogoPath;
  final String? smallLogoPath;
  final bool isActive;
  final bool isApproved;
  final String stateStatus;

  AgencyInfoModel({
    required this.agencyID,
    required this.name,
    required this.agencyName,
    required this.emailAddress,
    required this.contactNumber,
    this.fullLogoPath,
    this.smallLogoPath,
    required this.isActive,
    required this.isApproved,
    required this.stateStatus,
  });

  factory AgencyInfoModel.fromJson(Map<String, dynamic> json) {
    return AgencyInfoModel(
      agencyID: json['agencyID'] ?? '',
      name: json['name'] ?? '',
      agencyName: json['agencyName'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      fullLogoPath: json['fullLogoPath'],
      smallLogoPath: json['smallLogoPath'],
      isActive: json['isActive'] ?? false,
      isApproved: json['isApproved'] ?? false,
      stateStatus: json['stateStatus'] ?? '',
    );
  }
}
