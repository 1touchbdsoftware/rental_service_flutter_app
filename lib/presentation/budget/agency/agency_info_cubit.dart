import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rental_service/service_locator.dart';


import '../../../data/model/complain/agency_info_model.dart';
import '../../../domain/repository/complains_repository.dart';
import 'agency_info_state.dart';


class GetAgencyInfoCubit extends Cubit<GetAgencyInfoState> {
  GetAgencyInfoCubit() : super(GetAgencyInfoInitialState());

  Future<void> fetchAgencyInfo() async {
    emit(GetAgencyInfoLoadingState());

    try {
      final Either<String, AgencyInfoModel> result =
      await sl<ComplainsRepository>().getAgencyInfo();

      result.fold(
            (error) {
          print("Agency Info error: $error");
          emit(GetAgencyInfoFailureState(errorMessage: error));
        },
            (agencyInfo) {
          print("Successfully fetched agency info: ${agencyInfo.agencyName}");
          emit(GetAgencyInfoSuccessState(agencyInfo));
        },
      );
    } catch (e) {
      print("Unexpected error in GetAgencyInfoCubit: $e");
      emit(GetAgencyInfoFailureState(
          errorMessage: 'Unexpected error: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(GetAgencyInfoInitialState());
  }
}
