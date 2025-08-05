
abstract class PostBudgetState {}

class PostBudgetInitialState extends PostBudgetState {}

class PostBudgetLoadingState extends PostBudgetState {}

class PostBudgetSuccessState extends PostBudgetState {}

class PostBudgetFailureState extends PostBudgetState {
  final String errorMessage;
  PostBudgetFailureState({required this.errorMessage});
}