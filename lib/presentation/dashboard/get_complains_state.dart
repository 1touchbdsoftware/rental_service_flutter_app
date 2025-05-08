
import 'package:equatable/equatable.dart';

import '../../data/model/complain_response_model.dart';

abstract class GetTenantComplainsState{

}

class GetTenantComplainsInitialState extends GetTenantComplainsState{}

class GetTenantComplainsLoadingState extends GetTenantComplainsState{}

class GetTenantComplainsSuccessState extends GetTenantComplainsState with EquatableMixin {
  final ComplainResponseModel response;

  GetTenantComplainsSuccessState(this.response);

  @override
  List<Object?> get props => [response];
}

class GetTenantComplainsFailureState extends GetTenantComplainsState{
  final String errorMessage;

  GetTenantComplainsFailureState({required this.errorMessage});
}