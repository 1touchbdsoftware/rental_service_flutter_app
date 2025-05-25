class ComplainToApprove {
  final String landlordID;
  final String agencyID;
  final String? complainInfoID;
  final String complainID;
  final String stateStatus;
  final String? comments;
  final String? ticketNo;
  final String? lastComments;
  final String currentComments;
  final bool isApproved;

  ComplainToApprove({
    required this.landlordID,
    required this.agencyID,
    this.complainInfoID,
    required this.complainID,
    required this.stateStatus,
    this.comments,
    this.ticketNo,
    this.lastComments,
    required this.currentComments,
    required this.isApproved,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'landlordID': landlordID,
      'agencyID': agencyID,
      'complainID': complainID,
      'stateStatus': stateStatus,
      'currentComments': currentComments,
      'isApproved': isApproved,
    };

    if (complainInfoID != null) data['complainInfoID'] = complainInfoID;
    if (comments != null) data['comments'] = comments;
    if (ticketNo != null) data['ticketNo'] = ticketNo;
    if (lastComments != null) data['lastComments'] = lastComments;

    return data;
  }
}
