import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../service_locator.dart';
import '../../data/model/complain/complain_req_params/complain_edit_post_params.dart';
import '../../domain/usecases/edit_complain_usecase.dart';
import '../create_complain/bloc/complain_state.dart';


class EditComplainCubit extends Cubit<ComplainState> {
  final EditComplainUseCase _editComplainUseCase;

  EditComplainCubit({EditComplainUseCase? useCase})
      : _editComplainUseCase = useCase ?? sl<EditComplainUseCase>(),
        super(ComplainInitial());

  Future<void> editComplaint(ComplainEditPostParams model) async {
    emit(ComplainLoading());

    try {
      final result = await _editComplainUseCase(param: model);

      result.fold(
            (failure) {
          print("Edit Complain Cubit error: $failure");
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