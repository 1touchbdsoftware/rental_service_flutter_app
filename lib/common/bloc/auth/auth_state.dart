part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

class Authenticated extends AuthState {}

class UnAuthenticated extends AuthState {}