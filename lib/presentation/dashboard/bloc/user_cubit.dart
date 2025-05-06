import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repository/user_repository.dart';
import '../../../service_locator.dart';

class UsernameCubit extends Cubit<String?> {


  UsernameCubit() : super(null);

  Future<void> loadUsername() async {
    String? username = await sl<UserRepository>().getSavedUsername();

    emit(username); // Update state with the fetched username
  }
}