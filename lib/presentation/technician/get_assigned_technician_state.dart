part of 'get_assigned_technician_cubit.dart';

@immutable
sealed class GetAssignedTechnicianState {}

final class GetAssignedTechnicianInitialState extends GetAssignedTechnicianState {}

class GetAssignedTechnicianLoadingState extends GetAssignedTechnicianState {}

class GetAssignedTechnicianSuccessState extends GetAssignedTechnicianState {
  final TechnicianResponse response;

  GetAssignedTechnicianSuccessState(this.response);

  @override
  List<Object?> get props => [response];
}

class GetAssignedTechnicianFailureState extends GetAssignedTechnicianState {
  final String errorMessage;

  GetAssignedTechnicianFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}