import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';

class GetTenantComplainsCubit extends Cubit<GetTenantComplainsState> {
  final GetTenantComplainsUseCase useCase;

  GetTenantComplainsCubit({required this.useCase}) : super(GetTenantComplainsInitialState());

  Future<void> fetchComplains({required GetComplainsParams params}) async {
    emit(GetTenantComplainsLoadingState());

    try {
      print("Cubit: Before calling usecase");

      Either result = await useCase.call(param: params);
      print("Cubit: Result type: ${result.runtimeType}");
      print("Cubit: Result type: $result");
      print("Cubit: After calling usecase");

      result.fold(
            (error) {
          // print("Cubit: Error path, error value: '$error'");
          // Safely handle null by providing a default error message
          final safeErrorMessage = error ?? "Unknown error occurred";
          emit(GetTenantComplainsFailureState(errorMessage: safeErrorMessage));
        },
            (response) {
          print("Cubit: Success path, message: ${response.message}");
          emit(GetTenantComplainsSuccessState(response));
        },
      );
    } catch (e) {
      print("Cubit: Exception caught: $e");
      emit(GetTenantComplainsFailureState(errorMessage: e.toString()));
    }
  }
}