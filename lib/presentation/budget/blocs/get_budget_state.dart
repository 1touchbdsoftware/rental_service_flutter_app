// get_budget_state.dart



import '../../../data/model/budget/BudgetItem.dart';


abstract class GetBudgetState {}

class GetBudgetInitialState extends GetBudgetState {}

class GetBudgetLoadingState extends GetBudgetState {}

class GetBudgetSuccessState extends GetBudgetState {
  final List<BudgetItem> budgetItems;

  GetBudgetSuccessState(this.budgetItems);
}

class GetBudgetFailureState extends GetBudgetState {
  final String errorMessage;

  GetBudgetFailureState({required this.errorMessage});
}