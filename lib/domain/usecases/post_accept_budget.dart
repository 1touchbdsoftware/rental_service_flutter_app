import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../../data/model/budget/budget_post_model.dart';
import '../../service_locator.dart';
import '../repository/complains_repository.dart';

class AcceptBudgetUseCase implements UseCase<Either<String, bool>, Tuple2<BudgetPostModel, bool>> {
  @override
  Future<Either<String, bool>> call({Tuple2<BudgetPostModel, bool>? param}) async {
    if (param == null || param.value1 == null) {
      return Left('Budget parameters cannot be null');
    }

    final budgetModel = param.value1;
    final isReview = param.value2;

    return sl<ComplainsRepository>().postAcceptBudget(
      budgetModel: budgetModel,
      isReview: isReview,
    );
  }
}