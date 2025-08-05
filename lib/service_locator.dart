

import 'package:get_it/get_it.dart';
import 'package:rental_service/core/network/dio_client.dart';
import 'package:rental_service/data/repository/complains_repository.dart';
import 'package:rental_service/data/repository/technician_repository.dart';
import 'package:rental_service/data/repository/user_repository.dart';
import 'package:rental_service/data/source/api_service/complains_api_service.dart';
import 'package:rental_service/data/source/api_service/technician_api_service.dart';
import 'package:rental_service/data/source/api_service/get_history_api_service.dart';
import 'package:rental_service/data/source/api_service/get_segment_api_service.dart';
import 'package:rental_service/data/source/local_service/get_user_local_service.dart';
import 'package:rental_service/domain/repository/complains_repository.dart';
import 'package:rental_service/domain/repository/history_repository.dart';
import 'package:rental_service/domain/repository/segment_repository.dart';
import 'package:rental_service/domain/repository/technician_repository.dart';
import 'package:rental_service/domain/repository/user_repository.dart';
import 'package:rental_service/domain/usecases/edit_complain_usecase.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';
import 'package:rental_service/domain/usecases/get_history_usecase.dart';
import 'package:rental_service/domain/usecases/get_images_usecase.dart';
import 'package:rental_service/domain/usecases/get_segment_usecase.dart';
import 'package:rental_service/domain/usecases/get_technician_usecase.dart';
import 'package:rental_service/domain/usecases/get_user_type_usecase.dart';
import 'package:rental_service/domain/usecases/is_loggedin_usecase.dart';
import 'package:rental_service/domain/usecases/logout_usecase.dart';
import 'package:rental_service/presentation/resubmit/resubmit_form_screen.dart';

import 'data/repository/auth_repository.dart';
import 'data/repository/history_repository.dart';
import 'data/repository/segment_repository.dart';
import 'data/source/api_service/auth_api_service.dart';
import 'data/source/local_service/auth_local_service.dart';
import 'domain/repository/auth.dart';
import 'domain/usecases/get_budget_usecase.dart';
import 'domain/usecases/get_completed_complains_usecase.dart';
import 'domain/usecases/mark_as_complete_usecase.dart';
import 'domain/usecases/post_accept_budget.dart';
import 'domain/usecases/post_accept_technician_usecase.dart';
import 'domain/usecases/post_approve_complain_landlord_usecase.dart';
import 'domain/usecases/post_change_password_usecase.dart';
import 'domain/usecases/post_forgot_pass_req.dart';
import 'domain/usecases/post_otp_verification.dart';
import 'domain/usecases/post_reschedule_technician_usecase.dart';
import 'domain/usecases/recomplain_usecase.dart';
import 'domain/usecases/signin_usecase.dart';


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

  sl.registerSingleton<GetUserLocalService>(
      GetUserLocalServiceImpl()
  );

  sl.registerSingleton<ComplainApiService>(
      ComplainApiServiceImpl()
  );

  sl.registerSingleton<SegmentApiService>(
      SegmentApiServiceImpl()
  );

  sl.registerSingleton<TechnicianApiService>(
      TechnicianApiServiceImpl()
  );

  sl.registerSingleton<HistoryApiService>(
      HistoryApiServiceImpl()
  );


  // Repositories
  sl.registerSingleton<AuthRepository>(
      AuthRepositoryImpl()
  );

  sl.registerSingleton<UserRepository>(
      UserRepositoryImpl()
  );

  sl.registerSingleton<ComplainsRepository>(
      ComplainsRepositoryImpl()
  );

  sl.registerSingleton<SegmentRepository>(
      SegmentRepositoryImpl()
  );

  sl.registerSingleton<TechnicianRepository>(
      TechnicianRepositoryImpl()
  );

  sl.registerSingleton<HistoryRepository>(
      HistoryRepositoryImpl()
  );


  //UseCases:

  sl.registerSingleton<SigninUseCase>(
    SigninUseCase()
  );

  sl.registerSingleton<IsLoggedinUsecase>(
      IsLoggedinUsecase()
  );

  sl.registerSingleton<GetUserTypeUseCase>(
      GetUserTypeUseCase()
  );

  sl.registerLazySingleton<GetTenantComplainsUseCase>(
        () => GetTenantComplainsUseCase(),
  );

  sl.registerLazySingleton<GetAssignedTechnicianUseCase>(
        () => GetAssignedTechnicianUseCase(),
  );

  sl.registerLazySingleton<GetHistoryUseCase>(
        () => GetHistoryUseCase(),
  );

  sl.registerLazySingleton<AcceptTechnicianUseCase>(
        () => AcceptTechnicianUseCase(),
  );

  sl.registerLazySingleton<RescheduleTechnicianUseCase>(
        () => RescheduleTechnicianUseCase(),
  );

  sl.registerLazySingleton<EditComplainUseCase>(
        () => EditComplainUseCase(),
  );

  sl.registerLazySingleton<ReComplainUseCase>(
        () => ReComplainUseCase()
  );


  // sl.registerLazySingleton<GetTenantCompletedComplainsUseCase>(
  //       () => GetTenantCompletedComplainsUseCase(),
  // );


  sl.registerSingleton<LogoutUseCase>(
      LogoutUseCase()
  );

  sl.registerSingleton<GetSegmentUseCase>(
      GetSegmentUseCase()
  );

  sl.registerSingleton<MarkComplainCompletedUseCase>(
      MarkComplainCompletedUseCase()
  );

  sl.registerSingleton<GetComplainImagesUseCase>(
      GetComplainImagesUseCase()
  );

  sl.registerSingleton<ApproveComplaintsUseCase>(
      ApproveComplaintsUseCase()
  );

  sl.registerSingleton<ChangePasswordUseCase>(
      ChangePasswordUseCase()
  );

  sl.registerSingleton<ForgotPasswordUseCase>(
      ForgotPasswordUseCase()
  );

  sl.registerSingleton<VerifyOtpUseCase>(
      VerifyOtpUseCase()
  );
  sl.registerSingleton<GetBudgetUseCase>(
      GetBudgetUseCase()
  );
  sl.registerSingleton<AcceptBudgetUseCase>(
      AcceptBudgetUseCase()
  );



  //logout or other use cases

}