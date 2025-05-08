
class GetComplainsParams {
  final String agencyID;
  final int pageNumber;
  final int pageSize;
  final bool isActive;
  final String? landlordID;
  final String? propertyID;
  final String? tenantID;
  final String flag;

  GetComplainsParams({
    required this.agencyID,
    required this.pageNumber,
    required this.pageSize,
    required this.isActive,
    this.landlordID,
    this.propertyID,
    this.tenantID,
    required this.flag,
  });
}