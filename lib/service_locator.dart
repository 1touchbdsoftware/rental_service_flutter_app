

import 'package:get_it/get_it.dart';
import 'package:rental_service/core/network/dio_client.dart';

import 'data/repository/auth.dart';
import 'data/source/auth_api_service.dart';
import 'data/source/auth_local_service.dart';
import 'domain/repository/auth.dart';
import 'domain/usecases/signin.dart';


//dependency injection file service_locator.dart

final sl = GetIt.instance;

void setupServiceLocator(){

  //register dio client to use
  sl.registerSingleton<DioClient>(DioClient());

  // Services
  sl.registerSingleton<AuthApiService>(
      AuthApiServiceImpl()
  );

  sl.registerSingleton<AuthLocalService>(
      AuthLocalServiceImpl()
  );


  // Repositories
  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl()
  );

  //UseCases:

  sl.registerSingleton<SigninUseCase>(
    SigninUseCase()
  );

  //logout or other use cases

}