
import 'package:equatable/equatable.dart';

import '../../../data/model/complain/complain_response_model.dart';

abstract class GetComplainsState{

}

class GetComplainsInitialState extends GetComplainsState{}

class GetComplainsLoadingState extends GetComplainsState{}

class GetComplainsNoInternetState extends GetComplainsState{}

class GetComplainsSuccessState extends GetComplainsState with EquatableMixin {
  final ComplainResponseModel response;

  GetComplainsSuccessState(this.response);

  @override
  List<Object?> get props => [response];
}

class GetComplainsFailureState extends GetComplainsState{
  final String errorMessage;

  GetComplainsFailureState({required this.errorMessage});
}