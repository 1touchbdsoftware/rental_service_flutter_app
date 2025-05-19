part of 'get_history_cubit.dart';

@immutable
sealed class GetHistoryState {}

final class GetHistoryInitialState extends GetHistoryState {}

final class GetHistoryLoadingState extends GetHistoryState {}

final class GetHistorySuccessState extends GetHistoryState {
  final HistoryResponseModel historyResponse;

  GetHistorySuccessState(this.historyResponse);

  List<Object?> get props => [historyResponse];
}

final class GetHistoryFailureState extends GetHistoryState {
  final String errorMessage;

  GetHistoryFailureState({required this.errorMessage});

  List<Object?> get props => [errorMessage];
}