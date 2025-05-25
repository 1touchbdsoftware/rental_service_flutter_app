import 'complains_to_approve.dart';

class ComplainApprovalRequestModel {
  final String flag;
  final List<ComplainToApprove> complainsToApprove;

  ComplainApprovalRequestModel({
    required this.flag,
    required this.complainsToApprove,
  });

  Map<String, dynamic> toJson() => {
    'flag': flag,
    'complainsToApprove': complainsToApprove.map((e) => e.toJson()).toList(),
  };
}
