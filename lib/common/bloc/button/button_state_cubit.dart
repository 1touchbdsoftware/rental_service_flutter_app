import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../core/usecase/usecase.dart';
import 'button_state.dart';

class ButtonStateCubit extends Cubit<ButtonState> {
  ButtonStateCubit() : super(ButtonInitialState());

  final Logger _logger = Logger();

  void execute({dynamic params, required UseCase usecase}) async {
    emit(ButtonLoadingState());

    try {
      Either result = await usecase.call(param: params);

      // Enhanced debugging
      _logger.d("Login Cubit: Result type: ${result.runtimeType}");
      _logger.d("Login Cubit: Full result: $result");

      result.fold(
        // Left side - Error case
            (error) {
          _logger.e("Login failed with error: $error");
          _logger.e("Error type: ${error.runtimeType}");

          // Check if it's actually a success disguised as an error
          if (error.toString().contains('success') ||
              error.toString().contains('Success') ||
              error.toString().contains('200')) {
            _logger.w("Success response detected in error case - treating as success");
            emit(ButtonSuccessState());
          } else {
            emit(ButtonFailureState(errorMessage: error.toString()));
          }
        },
        // Right side - Success case
            (data) {
          _logger.i("Login successful with data: $data");
          _logger.i("Data type: ${data.runtimeType}");
          emit(ButtonSuccessState());
        },
      );
    } catch (e, stackTrace) {
      _logger.e("Exception in ButtonStateCubit: ${e.toString}",
          error: e, stackTrace: stackTrace);
      emit(ButtonFailureState(errorMessage: e.toString()));
    }
  }
}