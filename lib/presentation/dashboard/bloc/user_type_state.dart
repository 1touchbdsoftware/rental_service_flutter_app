part of 'user_type_cubit.dart';

@immutable
sealed class UserTypeState {}

final class UserTypeInitialState extends UserTypeState {}

class UserTypeLandLord extends UserTypeState {}

class UserTypeTenant extends UserTypeState {}
