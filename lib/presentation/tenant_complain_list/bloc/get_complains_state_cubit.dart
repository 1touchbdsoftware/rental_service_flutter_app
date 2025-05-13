import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/presentation/tenant_complain_list/bloc/get_complains_state.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';

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
      // Get the result from the use case
      final Either<String, ComplainResponseModel> result =
      await _useCase.call(param: params);

      print("Cubit:result type: ${result.runtimeType}");
      // Process the result using fold without a try/catch around it
      result.fold(
              (error) {
            print("Detailed error: $error"); // Add this line
            emit(GetTenantComplainsFailureState(errorMessage: error));
          },
              (data) => emit(GetTenantComplainsSuccessState(data))
      );
    } catch (e) {
      print("Cubit:Catch block called}");
      // This should only catch errors in the service locator or emit calls
      emit(GetTenantComplainsFailureState(errorMessage: 'Unexpected error: ${e.toString()}'));
    }
  }
}
