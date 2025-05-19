import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../data/model/history/history_query_params.dart';
import '../../data/model/history/history_response_model.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../service_locator.dart';

part 'get_history_state.dart';



class GetHistoryCubit extends Cubit<GetHistoryState> {
  final GetHistoryUseCase _useCase;

  GetHistoryCubit({GetHistoryUseCase? useCase})
      : _useCase = useCase ?? sl<GetHistoryUseCase>(),
        super(GetHistoryInitialState());

  Future<void> fetchHistory({required HistoryQueryParams params}) async {
    emit(GetHistoryLoadingState());

    try {
      final Either<String, HistoryResponseModel> result =
      await _useCase.call(param: params);

      result.fold(
            (error) {
          print("History Cubit error: $error");
          emit(GetHistoryFailureState(errorMessage: error));
        },
            (data) {
          emit(GetHistorySuccessState(data));
        },
      );
    } catch (e) {
      emit(GetHistoryFailureState(
        errorMessage: 'History Unexpected error: ${e.toString()}',
      ));
    }
  }
}
