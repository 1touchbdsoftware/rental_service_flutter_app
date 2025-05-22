import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../service_locator.dart';
import '../../../data/model/complain/complain_req_params/completed_post_req.dart';
import '../../../domain/usecases/mark_as_complete_usecase.dart';
import '../../create_complain/bloc/complain_state.dart';

class MarkComplainCompletedCubit extends Cubit<ComplainState> {
  final MarkComplainCompletedUseCase _markComplainCompletedUseCase;

  MarkComplainCompletedCubit({MarkComplainCompletedUseCase? useCase})
      : _markComplainCompletedUseCase = useCase ?? sl<MarkComplainCompletedUseCase>(),
        super(ComplainInitial());

  Future<void> markAsCompleted(ComplainCompletedRequest params) async {
    emit(ComplainLoading());

    try {
      final result = await _markComplainCompletedUseCase(param: params);

      result.fold(
            (failure) {
          print("MarkComplainCompleted Cubit error: $failure");
          emit(ComplainError(failure));
        },
            (success) {
          emit(ComplainSuccess());
        },
      );
    } catch (e) {
      emit(ComplainError('Unexpected error: ${e.toString()}'));
    }
  }
}