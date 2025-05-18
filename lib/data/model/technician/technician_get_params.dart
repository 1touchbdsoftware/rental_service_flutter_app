class TechnicianRequestParams {
  final String? technicianAssignID;
  final String agencyID;
  final String complainID;
  final String tenantID;
  final String technicianID;
  final String propertyID;
  final String landlordID;
  final String isActive;
  final String? isApproved;


  TechnicianRequestParams({
     this.technicianAssignID,
    required this.agencyID,
    required this.complainID,
    required this.tenantID,
    required this.technicianID,
    required this.propertyID,
    required this.landlordID,
    required this.isActive,
     this.isApproved,
  });

}