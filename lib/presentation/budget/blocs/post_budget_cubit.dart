// post_budget_cubit.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/budget/blocs/post_budget_state.dart';
import 'package:rental_service/service_locator.dart';
import 'package:rental_service/data/model/budget/budget_post_model.dart';

import '../../../domain/usecases/post_accept_budget.dart';



class PostBudgetCubit extends Cubit<PostBudgetState> {
  final AcceptBudgetUseCase _useCase;

  PostBudgetCubit({AcceptBudgetUseCase? useCase})
      : _useCase = useCase ?? sl<AcceptBudgetUseCase>(),
        super(PostBudgetInitialState());

  Future<void> postBudget({
    required BudgetPostModel budgetModel,
  }) async {
    emit(PostBudgetLoadingState());

    try {
      final Either<String, bool> result =
      await _useCase.call(param: budgetModel);

      result.fold(
            (error) {
          print("Budget post error: $error");
          emit(PostBudgetFailureState(errorMessage: error));
        },
            (isSuccess) {
          if (isSuccess) {
            print("Successfully posted budget");
            emit(PostBudgetSuccessState());
          } else {
            print("Budget post operation failed");
            emit(PostBudgetFailureState(
                errorMessage: 'Operation completed but was not successful'));
          }
        },
      );
    } catch (e) {
      print("Unexpected error in PostBudgetCubit: $e");
      emit(PostBudgetFailureState(
          errorMessage: 'Unexpected error: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(PostBudgetInitialState());
  }
}