

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/technician/bloc/technician_post_state.dart';

import '../../../data/model/technician/post_accept_technician_params.dart';
import '../../../data/model/technician/technician_response_model.dart';
import '../../../domain/repository/technician_repository.dart';
import '../../../domain/usecases/post_accept_technician_usecase.dart';
import '../../../service_locator.dart';

class AcceptTechnicianCubit extends Cubit<TechnicianPostState> {
  final AcceptTechnicianUseCase _useCase;

  AcceptTechnicianCubit({AcceptTechnicianUseCase? useCase})
      : _useCase = useCase ?? sl<AcceptTechnicianUseCase>(),
        super(TechnicianPostInitial());

  Future<void> acceptTechnician({
    required AcceptTechnicianParams params,
  }) async {
    emit(TechnicianPostLoading());

    try {
      final result = await _useCase.call(param: params);

      result.fold(
            (error) {
          print("Accept Technician Cubit error: $error");
          emit(TechnicianPostError(error));
        },
            (data) {
          emit(TechnicianPostSuccess());
        },
      );
    } catch (e) {
      emit(TechnicianPostError(
          'Accept Technician Unexpected error: ${e.toString()}'));
    }
  }
}
