import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../../data/model/budget/budget_post_model.dart';
import '../../service_locator.dart';
import '../repository/complains_repository.dart';

class AcceptBudgetUseCase implements UseCase<Either<String, bool>, BudgetPostModel> {
  @override
  Future<Either<String, bool>> call({BudgetPostModel? param}) async {
    if (param == null) {
      return Left('Budget parameters cannot be null');
    }

    return sl<ComplainsRepository>().postAcceptBudget(param);
  }
}