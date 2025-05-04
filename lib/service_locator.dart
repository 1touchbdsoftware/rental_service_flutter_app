

import 'package:get_it/get_it.dart';
import 'package:rental_service/core/network/dio_client.dart';

import 'domain/usecases/signin.dart';


//dependency injection file service_locator.dart

final sl = GetIt.instance;

void setupServiceLocator(){

  //register dio client to use

  sl.registerSingleton<DioClient>(DioClient());

  sl.registerSingleton<SigninUseCase>(
    SigninUseCase()
  );

}