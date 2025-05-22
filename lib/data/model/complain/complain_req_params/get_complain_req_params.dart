
class GetComplainsParams {
  final String agencyID;
  final int pageNumber;
  final int pageSize;
  final bool? isActive;
  final String? landlordID;
  final String? propertyID;
  final String? tenantID;
  final String flag;
  final String tab;

  GetComplainsParams({
    required this.agencyID,
    required this.pageNumber,
    required this.pageSize,
    this.isActive,
    this.landlordID,
    this.propertyID,
    this.tenantID,
    required this.flag,
    required this.tab,
  });
}