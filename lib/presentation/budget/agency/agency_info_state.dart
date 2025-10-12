import 'package:equatable/equatable.dart';

import '../../../data/model/complain/agency_info_model.dart';


abstract class GetAgencyInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAgencyInfoInitialState extends GetAgencyInfoState {}

class GetAgencyInfoLoadingState extends GetAgencyInfoState {}

class GetAgencyInfoSuccessState extends GetAgencyInfoState {
  final AgencyInfoModel agencyInfo;

  GetAgencyInfoSuccessState(this.agencyInfo);

  @override
  List<Object?> get props => [agencyInfo];
}

class GetAgencyInfoFailureState extends GetAgencyInfoState {
  final String errorMessage;

  GetAgencyInfoFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
