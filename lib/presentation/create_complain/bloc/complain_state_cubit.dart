import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../data/model/complain/complain_req_params/complain_post_req.dart';
import '../../../domain/repository/complains_repository.dart';
import 'complain_state.dart';


class ComplainCubit extends Cubit<ComplainState> {
  final ComplainsRepository repository;

  ComplainCubit(this.repository) : super(ComplainInitial());

  Future<void> submitComplaint(ComplainPostModel model) async {
    emit(ComplainLoading());

    final result = await repository.saveComplain(model);

    result.fold(
          (failure) => emit(ComplainError(failure)),
          (success) => emit(ComplainSuccess()),
    );
  }
}
