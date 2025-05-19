class History {
  final int id;
  final String logID;
  final String complainID;
  final String agencyID;
  final String comments;
  final String stateStatus;
  final String updatedBy;
  final DateTime updatedDate;
  final bool? isActive;
  final String? activationStatus;

  History({
    required this.id,
    required this.logID,
    required this.complainID,
    required this.agencyID,
    required this.comments,
    required this.stateStatus,
    required this.updatedBy,
    required this.updatedDate,
    this.isActive,
    this.activationStatus,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      logID: json['logID'],
      complainID: json['complainID'],
      agencyID: json['agencyID'],
      comments: json['comments'],
      stateStatus: json['stateStatus'],
      updatedBy: json['updatedBy'],
      updatedDate: DateTime.parse(json['updatedDate']),
      isActive: json['isActive'],
      activationStatus: json['activationStatus'],
    );
  }
}
