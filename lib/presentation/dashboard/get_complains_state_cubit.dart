import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state.dart';

import '../../data/model/complain_response_model.dart';
import '../../domain/usecases/get_complains_usecase.dart';



class GetTenantComplainsCubit extends Cubit<GetTenantComplainsState> {
  GetTenantComplainsCubit() : super(GetTenantComplainsInitialState());

  void fetchComplains({required GetComplainsParams params, required GetTenantComplainsUseCase useCase}) async {
    emit(GetTenantComplainsLoadingState());

    try {
      print("Before calling usecase");
      Either<String, ComplainResponseModel> result = await useCase.call(param: params);
      print("After calling usecase");

      result.fold(
            (error) {
          print("Error: $error");
          emit(GetTenantComplainsFailureState(errorMessage: error));
        },
            (data) {
          print("Success: ${data.message}");
          emit(GetTenantComplainsSuccessState(data));
        },
      );
    } catch (e) {
      print("Exception: $e");
      emit(GetTenantComplainsFailureState(errorMessage: e.toString()));
    }
  }
}