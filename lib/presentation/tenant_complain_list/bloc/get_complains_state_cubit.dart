import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:rental_service/domain/usecases/get_pending_complains_usecase.dart';
import 'package:rental_service/domain/usecases/get_completed_complains_usecase.dart';

import '../../../data/model/complain/complain_response_model.dart';
import '../../../service_locator.dart';

class GetTenantComplainsCubit extends Cubit<GetTenantComplainsState> {
  final GetTenantPendingComplainsUseCase _pendingUseCase;
  final GetTenantCompletedComplainsUseCase _completedUseCase;

  GetTenantComplainsCubit({
    GetTenantPendingComplainsUseCase? pendingUseCase,
    GetTenantCompletedComplainsUseCase? completedUseCase,
  })  : _pendingUseCase = pendingUseCase ?? sl<GetTenantPendingComplainsUseCase>(),
        _completedUseCase = completedUseCase ?? sl<GetTenantCompletedComplainsUseCase>(),
        super(GetTenantComplainsInitialState());

  Future<void> fetchPendingComplains({required GetComplainsParams params}) async {
    emit(GetTenantComplainsLoadingState());
    final Either<String, ComplainResponseModel> result =
    await _pendingUseCase.call(param: params);

    result.fold(
          (error) {
        print("Pending error: $error");
        emit(GetTenantComplainsFailureState(errorMessage: error));
      },
          (data) => emit(GetTenantComplainsSuccessState(data)),
    );
  }

  Future<void> fetchCompletedComplains({required GetComplainsParams params}) async {
    emit(GetTenantComplainsLoadingState());
    final Either<String, ComplainResponseModel> result =
    await _completedUseCase.call(param: params);

    result.fold(
          (error) {
        print("Completed error: $error");
        emit(GetTenantComplainsFailureState(errorMessage: error));
      },
          (data) => emit(GetTenantComplainsSuccessState(data)),
    );
  }
}
