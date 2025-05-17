import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';
import 'package:rental_service/domain/usecases/get_completed_complains_usecase.dart';

import '../../../data/model/complain/complain_response_model.dart';
import '../../../service_locator.dart';

class GetTenantComplainsCubit extends Cubit<GetTenantComplainsState> {
  final GetTenantComplainsUseCase _useCase;

  GetTenantComplainsCubit({GetTenantComplainsUseCase? useCase})
      : _useCase = useCase ?? sl<GetTenantComplainsUseCase>(),
  super(GetTenantComplainsInitialState());

  Future<void> fetchComplains({required GetComplainsParams params}) async {
    emit(GetTenantComplainsLoadingState());

    try {
      final Either<String, ComplainResponseModel> result =
      await _useCase.call(param: params);

      result.fold(
            (error) {
          print("Pending error: $error");
          emit(GetTenantComplainsFailureState(errorMessage: error));
        },
            (data) => emit(GetTenantComplainsSuccessState(data)),
      );

    } catch (e) {
      print("Cubit:Catch block called}");
      // This should only catch errors in the service locator or emit calls
      emit(GetTenantComplainsFailureState(errorMessage: 'Unexpected error: ${e.toString()}'));
    }

  }

  // Future<void> fetchCompletedComplains({required GetComplainsParams params}) async {
  //   emit(GetTenantComplainsLoadingState());
  //   final Either<String, ComplainResponseModel> result =
  //   await _completedUseCase.call(param: params);
  //
  //   result.fold(
  //         (error) {
  //       print("Completed error: $error");
  //       emit(GetTenantComplainsFailureState(errorMessage: error));
  //     },
  //         (data) => emit(GetTenantComplainsSuccessState(data)),
  //   );
  // }
}
