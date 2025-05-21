
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../service_locator.dart';
import '../../data/model/complain/complain_req_params/recomplain_post_req.dart';
import '../../domain/usecases/recomplain_usecase.dart';
import '../create_complain/bloc/complain_state.dart';


class ReComplainCubit extends Cubit<ComplainState> {
  final ReComplainUseCase _reComplainUseCase;

  ReComplainCubit({ReComplainUseCase? useCase})
      : _reComplainUseCase = useCase ?? sl<ReComplainUseCase>(),
        super(ComplainInitial());

  Future<void> submitReComplain(ReComplainParams params) async {
    emit(ComplainLoading());

    try {
      final result = await _reComplainUseCase(param: params);

      result.fold(
            (failure) {
          print("ReComplain Cubit error: $failure");
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