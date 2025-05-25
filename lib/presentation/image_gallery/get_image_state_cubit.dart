// get_complain_images_cubit.dart
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/service_locator.dart';
import 'package:rental_service/data/model/complain/complain_image_model.dart';
import '../../data/model/complain/complain_req_params/complain_images_param.dart';
import '../../domain/usecases/get_images_usecase.dart';
import 'get_image_state.dart';


class GetComplainImagesCubit extends Cubit<GetComplainImagesState> {
  final GetComplainImagesUseCase _useCase;

  GetComplainImagesCubit({GetComplainImagesUseCase? useCase})
      : _useCase = useCase ?? sl<GetComplainImagesUseCase>(),
        super(GetComplainImagesInitialState());

  Future<void> fetchComplainImages({
    required String complainID,
    required String agencyID,
  }) async {
    emit(GetComplainImagesLoadingState());

    try {
      final Either<String, List<ComplainImageModel>> result =
      await _useCase.call(param: GetImagesParams(
        complainID: complainID,
        agencyID: agencyID,
      ));

      result.fold(
            (error) {
          print("Complain images error: $error");
          emit(GetComplainImagesFailureState(errorMessage: error));
        },
            (images) {
          print("Successfully fetched ${images.length} images");
          emit(GetComplainImagesSuccessState(images));
        },
      );
    } catch (e) {
      print("Unexpected error in GetComplainImagesCubit: $e");
      emit(GetComplainImagesFailureState(
          errorMessage: 'Unexpected error: ${e.toString()}'));
    }
  }

  void resetState() {
    emit(GetComplainImagesInitialState());
  }
}