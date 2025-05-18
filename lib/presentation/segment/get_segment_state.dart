import 'package:equatable/equatable.dart';

import '../../data/model/segment/segment_response_model.dart';


abstract class GetSegmentState {}

class GetSegmentInitialState extends GetSegmentState {}

class GetSegmentLoadingState extends GetSegmentState {}

class GetSegmentSuccessState extends GetSegmentState with EquatableMixin {
  final SegmentResponseModel response;

  GetSegmentSuccessState(this.response);

  @override
  List<Object?> get props => [response];
}

class GetSegmentFailureState extends GetSegmentState {
  final String errorMessage;

  GetSegmentFailureState({required this.errorMessage});
}
