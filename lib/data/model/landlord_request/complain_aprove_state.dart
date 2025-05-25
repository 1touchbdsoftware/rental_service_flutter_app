// complaint_approval_state.dart
abstract class ComplaintApprovalState {}

class ComplaintApprovalInitial extends ComplaintApprovalState {}
class ComplaintApprovalLoading extends ComplaintApprovalState {}
class ComplaintApprovalSuccess extends ComplaintApprovalState {
  final bool success;
  ComplaintApprovalSuccess(this.success);
}
class ComplaintApprovalError extends ComplaintApprovalState {
  final String message;
  ComplaintApprovalError(this.message);
}