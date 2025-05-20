

class AcceptTechnicianParams {

  final String technicianID;
  final String tenantID;
  final String complainID;
  final String agencyID;
  final String currentComments;

  AcceptTechnicianParams(
      {required this.technicianID, required this.tenantID, required this.complainID, required this.agencyID, required this.currentComments,});

  Map<String, dynamic> toJson() {
    return {
      'TechnicianID': technicianID,
      'TenantID': tenantID,
      'ComplainID': complainID,
      'AgencyID': agencyID,
      'currentComments': currentComments,
    };
  }

}