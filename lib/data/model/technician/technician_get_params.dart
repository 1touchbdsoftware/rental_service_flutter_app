class TechnicianRequestParams {
  final String? technicianAssignID;
  final String agencyID;
  final String complainID;
  final String tenantID;
  final String? technicianID;
  final String propertyID;



  TechnicianRequestParams({
     this.technicianAssignID,
    required this.agencyID,
    required this.complainID,
    required this.tenantID,
     this.technicianID,
    required this.propertyID,
  });

}