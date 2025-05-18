class TechnicianInfo {
  final int id;
  final String technicianAssignID;
  final String technicianCategoryID;
  final String technicianID;
  final String propertyID;
  final String tenantID;
  final String complainID;
  final String? stateStatus;
  final String? agencyID;
  final bool? isActive;
  final String? activationStatus;
  final bool? isApproved;
  final String? createdBy;
  final String? createdDate;
  final String? updatedBy;
  final String? updatedDate;
  final int? billingAmount;
  final int? paidAmount;
  final String? technicianCategoryName;
  final String? technicianName;
  final String? propertyName;
  final String? tenantName;
  final String? complainName;
  final bool? isSolved;
  final bool? isSentToLandlord;
  final bool? isAssignedTechnician;
  final bool? isRejected;
  final bool? isCompleted;
  final int? countOfRecomplained;
  final String? scheduleDate;
  final String? scheduleTime;
  final String? formattedScheduleTime;
  final String? rescheduleDate;
  final String? rescheduleTime;
  final String? formattedRescheduleTime;
  final String? emailAddress;
  final String? contactNumber;
  final String? companyName;

  TechnicianInfo({
    required this.id,
    required this.technicianAssignID,
    required this.technicianCategoryID,
    required this.technicianID,
    required this.propertyID,
    required this.tenantID,
    required this.complainID,
     this.stateStatus,
     this.agencyID,
     this.isActive,
     this.activationStatus,
     this.isApproved,
     this.createdBy,
     this.createdDate,
    this.updatedBy,
    this.updatedDate,
     this.billingAmount,
     this.paidAmount,
     this.technicianCategoryName,
     this.technicianName,
     this.propertyName,
     this.tenantName,
     this.complainName,
     this.isSolved,
     this.isSentToLandlord,
     this.isAssignedTechnician,
     this.isRejected,
     this.isCompleted,
     this.countOfRecomplained,
     this.scheduleDate,
     this.scheduleTime,
     this.formattedScheduleTime,
    this.rescheduleDate,
    this.rescheduleTime,
    this.formattedRescheduleTime,
    this.emailAddress,
    this.contactNumber,
    this.companyName,
  });

  factory TechnicianInfo.fromJson(Map<String, dynamic> json) {
    return TechnicianInfo(
      id: json['id'],
      technicianAssignID: json['technicianAssignID'],
      technicianCategoryID: json['technicianCategoryID'],
      technicianID: json['technicianID'],
      propertyID: json['propertyID'],
      tenantID: json['tenantID'],
      complainID: json['complainID'],
      stateStatus: json['stateStatus'],
      agencyID: json['agencyID'],
      isActive: json['isActive'],
      activationStatus: json['activationStatus'],
      isApproved: json['isApproved'],
      createdBy: json['createdBy'],
      createdDate: json['createdDate'],
      updatedBy: json['updatedBy'],
      updatedDate: json['updatedDate'],
      billingAmount: json['billingAmount'],
      paidAmount: json['paidAmount'],
      technicianCategoryName: json['technicianCategoryName'],
      technicianName: json['technicianName'],
      propertyName: json['propertyName'],
      tenantName: json['tenantName'],
      complainName: json['complainName'],
      isSolved: json['isSolved'],
      isSentToLandlord: json['isSentToLandlord'],
      isAssignedTechnician: json['isAssignedTechnician'],
      isRejected: json['isRejected'],
      isCompleted: json['isCompleted'],
      countOfRecomplained: json['countOfRecomplained'],
      scheduleDate: json['scheduleDate'],
      scheduleTime: json['scheduleTime'],
      formattedScheduleTime: json['formattedScheduleTime'],
      rescheduleDate: json['rescheduleDate'],
      rescheduleTime: json['rescheduleTime'],
      formattedRescheduleTime: json['formattedRescheduleTime'],
      emailAddress: json['emailAddress'],
      contactNumber: json['contactNumber'],
      companyName: json['companyName'],
    );
  }
}
