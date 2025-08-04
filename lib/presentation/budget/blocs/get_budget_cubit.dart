// get_budget_cubit.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/service_locator.dart';
import 'package:rental_service/data/model/budget/BudgetItem.dart';
import 'package:rental_service/domain/usecases/get_budget_usecase.dart';

import 'get_budget_state.dart';


class GetBudgetCubit extends Cubit<GetBudgetState> {
  final GetBudgetUseCase _useCase;

  GetBudgetCubit({GetBudgetUseCase? useCase})
      : _useCase = useCase ?? sl<GetBudgetUseCase>(),
        super(GetBudgetInitialState());

  Future<void> fetchBudget({
    required String complainID,
  }) async {
    emit(GetBudgetLoadingState());

    try {
      final Either<String, List<BudgetItem>> result =
      await _useCase.call(param: complainID);

      result.fold(
            (error) {
          print("Budget error: $error");
          emit(GetBudgetFailureState(errorMessage: error));
        },
            (budgetItems) {
          print("Successfully fetched ${budgetItems.length} budget items");
          emit(GetBudgetSuccessState(budgetItems));
        },
      );
    } catch (e) {
      print("Unexpected error in GetBudgetCubit: $e");
      emit(GetBudgetFailureState(
          errorMessage: 'Unexpected error: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(GetBudgetInitialState());
  }
}