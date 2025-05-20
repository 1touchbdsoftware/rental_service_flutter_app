
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/technician/post_reschedule_technician_params.dart';
import '../../../domain/usecases/post_reschedule_technician_usecase.dart';
import '../../../service_locator.dart';
import 'technician_post_state.dart';

class RescheduleTechnicianCubit extends Cubit<TechnicianPostState> {
  final RescheduleTechnicianUseCase _useCase;

  RescheduleTechnicianCubit({RescheduleTechnicianUseCase? useCase})
      : _useCase = useCase ?? sl<RescheduleTechnicianUseCase>(),
        super(TechnicianPostInitial());

  Future<void> rescheduleTechnician({
    required TechnicianRescheduleParams params,
  }) async {
    emit(TechnicianPostLoading());

    try {
      final result = await _useCase.call(param: params);

      result.fold(
            (error) {
          print("Reschedule Technician Cubit error: $error");
          emit(TechnicianPostError(error));
        },
            (data) {
          emit(TechnicianPostSuccess());
        },
      );
    } catch (e) {
      emit(TechnicianPostError(
          'Reschedule Technician Unexpected error: ${e.toString()}'));
    }
  }
}