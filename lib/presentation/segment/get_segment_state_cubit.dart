import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../service_locator.dart';
import '../../data/model/segment/get_segment_params.dart';
import '../../data/model/segment/segment_response_model.dart';
import '../../domain/usecases/get_segment_usecase.dart';
import 'get_segment_state.dart';

class GetSegmentCubit extends Cubit<GetSegmentState> {
  final GetSegmentUseCase _useCase;

  GetSegmentCubit({GetSegmentUseCase? useCase})
      : _useCase = useCase ?? sl<GetSegmentUseCase>(),
        super(GetSegmentInitialState());

  Future<void> fetchSegments({required GetSegmentParams params}) async {
    emit(GetSegmentLoadingState());

    try {
      final Either<String, SegmentResponseModel> result =
      await _useCase.call(param: params);

      print("Cubit:result type: ${result.runtimeType}");

      result.fold(
            (error) {
          print("Detailed error: $error");
          emit(GetSegmentFailureState(errorMessage: error));
        },
            (data) => emit(GetSegmentSuccessState(data)),
      );
    } catch (e) {
      print("Cubit:Catch block called");
      emit(GetSegmentFailureState(
          errorMessage: 'Unexpected error: ${e.toString()}'));
    }
  }
}

