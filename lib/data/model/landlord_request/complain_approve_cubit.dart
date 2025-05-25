
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/post_approve_complain_landlord_usecase.dart';
import '../../../service_locator.dart';
import 'complain_aproval_request_post.dart';
import 'complain_aprove_state.dart';

class ComplaintApprovalCubit extends Cubit<ComplaintApprovalState> {
  final ApproveComplaintsUseCase _useCase;

  ComplaintApprovalCubit({ApproveComplaintsUseCase? useCase})
      : _useCase = useCase ?? sl<ApproveComplaintsUseCase>(),
        super(ComplaintApprovalInitial());

// In ComplaintApprovalCubit
  Future<bool> approveComplaint(ComplainApprovalRequestModel request) async {
    emit(ComplaintApprovalLoading());
    final result = await _useCase.call(param: request);
    return result.fold(
          (error) {
        emit(ComplaintApprovalError(error));
        return false;
      },
          (success) {
        emit(ComplaintApprovalSuccess(success));
        return success;
      },
    );
  }
}