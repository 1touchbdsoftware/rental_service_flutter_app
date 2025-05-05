import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/usecase/usecase.dart';
import 'button_state.dart';

//we are making a Cubit of <ButtonState>
class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  final Logger _logger = Logger(); // Use logger for better debugging

  void execute({dynamic params, required UseCase usecase}) async {
    emit(ButtonLoadingState());



    try {
      Either result = await usecase.call(param: params);

      result.fold(
        //left
        (error) {

          emit(ButtonFailureState(errorMessage: error));
        },
        (data) {
          print("Success changed Called: ");
          emit(ButtonSuccessState());
        },
      );
    } catch (e, stackTrace) {

      _logger.e("Exception in ButtonStateCubit: ${e.toString()}", error: e, stackTrace: stackTrace);
      emit(ButtonFailureState(errorMessage: e.toString()));
    }
  }
}
