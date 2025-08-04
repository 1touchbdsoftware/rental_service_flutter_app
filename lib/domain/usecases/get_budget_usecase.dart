// get_budget_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import '../../core/usecase/usecase.dart';
import '../../data/model/budget/BudgetItem.dart';
import '../../service_locator.dart';


class GetBudgetUseCase
    implements UseCase<Either<String, List<BudgetItem>>, String> {

  @override
  Future<Either<String, List<BudgetItem>>> call({
    String? param, // required String param
  }) async {
    try {
      if (param == null) {
        return const Left('ComplainID cannot be null');
      }
      return await sl<ComplainsRepository>().getBudgetForComplain(
        complainID: param,
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}