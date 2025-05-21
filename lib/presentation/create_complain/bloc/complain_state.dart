abstract class ComplainState {}

class ComplainInitial extends ComplainState {}

class ComplainLoading extends ComplainState {}

class ComplainSuccess extends ComplainState {}


class ComplainError extends ComplainState {
  final String message;
  ComplainError(this.message);
}
