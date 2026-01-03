part of 'user_type_cubit.dart';

@immutable
abstract class UserTypeState {}

class UserTypeInitialState extends UserTypeState {}

class UserTypeLoadingState extends UserTypeState {}

class UserTypeLandLord extends UserTypeState {}

class UserTypeTenant extends UserTypeState {}

class UserTypeTechnician extends UserTypeState {}

class UserTypeError extends UserTypeState {
  final String message;
  UserTypeError({required this.message});
}
