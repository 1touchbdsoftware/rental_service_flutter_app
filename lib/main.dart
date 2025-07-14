import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';


import 'package:rental_service/core/theme/app_theme.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_type_cubit.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/tenant/tenent_home_screen.dart';
import 'package:rental_service/presentation/password/bloc/forgot_password_cubit.dart';
import 'package:rental_service/presentation/password/bloc/verify_otp_cubit.dart';
import 'package:rental_service/presentation/routes.dart';
import 'package:rental_service/service_locator.dart';

import 'core/localization/language_cubit.dart';
import 'l10n/generated/app_localizations.dart';

void main() {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..appStarted()),
        BlocProvider(create: (context) => UserTypeCubit()..getUserType()),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => ForgotPasswordCubit()),
        BlocProvider(create: (context) => VerifyOtpCubit()),

      ],
      child: MyAppContent(),

    );
  }

}

class MyAppContent extends StatelessWidget {
  const MyAppContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, Locale>(
      builder: (context, locale) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, authState) {
            return BlocBuilder<UserTypeCubit, UserTypeState>(
              builder: (context, userTypeState) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    locale: locale,
                    supportedLocales: S.supportedLocales,
                    localizationsDelegates: S.localizationsDelegates,
                    // fallbackLocale: const Locale('en'),
                    theme: AppTheme.lightTheme,
                    home: const SplashWrapper(),
                    onGenerateRoute: AppRoutes.generateRoute,
                    routes: AppRoutes.getRoutes());
              },
            );
          },
        );
      },
    );
  }
}


class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  SplashWrapperState createState() => SplashWrapperState();
}

class SplashWrapperState extends State<SplashWrapper> {

  @override
  void initState() {
    super.initState();

    // Remove the splash after the first frame
    WidgetsBinding.instance.addPostFrameCallback(( _) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<UserTypeCubit, UserTypeState>(
          builder: (context, userTypeState) {

            // Still waiting for data
            if (authState is AuthInitialState ||
                userTypeState is UserTypeInitialState ||
                userTypeState is UserTypeLoadingState) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Authenticated and user type known
            if (authState is Authenticated) {
              if (userTypeState is UserTypeLandLord) {
                return LandlordDashboard();
              } else if (userTypeState is UserTypeTenant) {
                return TenantHomeScreen();
              } else {
                return SignInPage();
              }
            }

            // Unauthenticated
            return SignInPage();
          },
        );
      },
    );
  }
}
