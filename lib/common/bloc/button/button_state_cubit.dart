

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../core/usecase/usecase.dart';
import 'button_state.dart';

class ButtonStateCubit extends Cubit<ButtonState>{
  ButtonStateCubit() : super(ButtonInitialState());

  void execute({dynamic params, required UseCase usecase}) async{

    emit(ButtonLoadingState());

    try {
      Either result = await usecase.call(param: params);
      
      result.fold(
              (error){
                emit(
                  ButtonFailureState(errorMessage: error)
                );
              },
              (data) {
                emit(
                  ButtonSuccessState()
                );
              }
      );

    }catch(e){
      emit(ButtonFailureState(errorMessage: e.toString()));
    }
  }
}