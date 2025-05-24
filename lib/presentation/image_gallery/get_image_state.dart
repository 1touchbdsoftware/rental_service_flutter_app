// get_complain_images_state.dart
import 'package:equatable/equatable.dart';
import 'package:rental_service/data/model/complain/complain_image_model.dart';

abstract class GetComplainImagesState {}

class GetComplainImagesInitialState extends GetComplainImagesState {}

class GetComplainImagesLoadingState extends GetComplainImagesState {}

class GetComplainImagesSuccessState extends GetComplainImagesState with EquatableMixin {
  final List<ComplainImageModel> images;

  GetComplainImagesSuccessState(this.images);

  @override
  List<Object?> get props => [images];
}

class GetComplainImagesFailureState extends GetComplainImagesState {
  final String errorMessage;

  GetComplainImagesFailureState({required this.errorMessage});
}