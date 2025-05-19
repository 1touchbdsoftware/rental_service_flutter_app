
import 'package:dartz/dartz.dart';

import '../../data/model/history/history_query_params.dart';
import '../../data/model/history/history_response_model.dart';

abstract class HistoryRepository {
  Future<Either<String, HistoryResponseModel>> getHistory(HistoryQueryParams params);
}