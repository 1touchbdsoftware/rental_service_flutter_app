class BudgetPostModel {
  final String complainID;
  final String comments;
  final String tenantID;
  final String agencyID;
  final DateTime createdDate;
  final String ticketNo;

  BudgetPostModel({
    required this.complainID,
    required this.comments,
    required this.tenantID,
    required this.agencyID,
    required this.createdDate,
    required this.ticketNo,
  });

  // Convert BudgetPostModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'complainID': complainID,
      'comments': comments,
      'tenantID': tenantID,
      'agencyID': agencyID,
      'createdDate': createdDate.toIso8601String(),
      'ticketNo': ticketNo,
    };
  }
}