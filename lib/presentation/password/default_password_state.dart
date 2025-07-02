// default_password_state.dart

abstract class DefaultPasswordState {}

class DefaultPasswordInitial extends DefaultPasswordState {}

class DefaultPasswordLoading extends DefaultPasswordState {}

class IsDefaultPasswordState extends DefaultPasswordState {
  final bool isDefaultPassword;

  IsDefaultPasswordState(this.isDefaultPassword);
}

class NotDefaultPasswordState extends DefaultPasswordState {
  final bool isDefaultPassword;

  NotDefaultPasswordState(this.isDefaultPassword);
}

class DefaultPasswordFailure extends DefaultPasswordState {
  final String errorMessage;

  DefaultPasswordFailure(this.errorMessage);
}
