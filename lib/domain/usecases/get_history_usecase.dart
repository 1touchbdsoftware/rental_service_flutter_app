import 'package:dartz/dartz.dart';

import '../../core/usecase/usecase.dart';
import '../../data/model/history/history_query_params.dart';
import '../../data/model/history/history_response_model.dart';
import '../../service_locator.dart';
import '../repository/history_repository.dart';

class GetHistoryUseCase
    implements UseCase<Either<String, HistoryResponseModel>, HistoryQueryParams> {

  @override
  Future<Either<String, HistoryResponseModel>> call({
    HistoryQueryParams? param,
  }) async {
    try {
      if (param == null) {
        return const Left('Parameters cannot be null');
      }

      return await sl<HistoryRepository>().getHistory(param);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
