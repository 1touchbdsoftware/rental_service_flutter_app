


import 'package:rental_service/core/usecase/usecase.dart';
import 'package:rental_service/domain/repository/auth.dart';
import '../../service_locator.dart';

class IsLoggedinUsecase implements UseCase<bool, dynamic>{

  @override
  Future<bool> call({dynamic param}) async {

    return sl<AuthRepository>().isLoggedIn();
  }


}