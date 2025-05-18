import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../data/model/technician/technician_get_params.dart';
import '../../data/model/technician/technician_response_model.dart';
import '../../domain/usecases/get_technician_usecase.dart';
import '../../service_locator.dart';

part 'get_assigned_technician_state.dart';

class GetAssignedTechnicianCubit extends Cubit<GetAssignedTechnicianState> {
  final GetAssignedTechnicianUseCase _useCase;

  GetAssignedTechnicianCubit({GetAssignedTechnicianUseCase? useCase})
      : _useCase = useCase ?? sl<GetAssignedTechnicianUseCase>(),
        super(GetAssignedTechnicianInitialState());

  Future<void> fetchAssignedTechnician({
    required TechnicianRequestParams params,
  }) async {
    emit(GetAssignedTechnicianLoadingState());

    try {
      final Either<String, TechnicianResponse> result =
      await _useCase.call(param: params);

      result.fold(
            (error) {
          print("Technician Cubit error: $error");
          emit(GetAssignedTechnicianFailureState(errorMessage: error));
        },
            (data) {
          emit(GetAssignedTechnicianSuccessState(data));
        },
      );
    } catch (e) {
      emit(GetAssignedTechnicianFailureState(
          errorMessage: 'Technician Unexpected error: ${e.toString()}'));
    }
  }
}
