import 'package:rental_service/core/usecase/usecase.dart';
import 'package:rental_service/domain/repository/user_repository.dart';

import '../../service_locator.dart';

class GetUserTypeUseCase implements UseCase<String, dynamic>{
  @override
  Future<String> call({param}) {
    return sl<UserRepository>().getUserType();
  }


}