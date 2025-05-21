
/// Model for complaint completion POST request
class ComplainCompletedRequest {
  final String complainID;
  final bool isCompleted;
  final String updatedBy;
  final String agencyID;
  final String feedback;
  final String currentComments;

  ComplainCompletedRequest({
    required this.complainID,
    required this.isCompleted,
    required this.updatedBy,
    required this.agencyID,
    required this.feedback,
    required this.currentComments,
  });

  /// Convert model to Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'complainID': complainID,
      'isCompleted': isCompleted,
      'updatedBy': updatedBy,
      'agencyID': agencyID,
      'feedback': feedback,
      'currentComments': currentComments,
    };
  }

  /// Create model from Map (from JSON)
  factory ComplainCompletedRequest.fromJson(Map<String, dynamic> json) {
    return ComplainCompletedRequest(
      complainID: json['complainID'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      updatedBy: json['updatedBy'] ?? '',
      agencyID: json['agencyID'] ?? '',
      feedback: json['feedback'] ?? '',
      currentComments: json['currentComments'] ?? '',
    );
  }
}