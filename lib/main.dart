import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';


import 'package:rental_service/core/theme/app_theme.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_type_cubit.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/tenant/tenent_home_screen.dart';
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
      ],
      child: MyAppContent(),

      // BlocBuilder<AuthCubit, AuthState>(
      //   builder: (context, authState) {
      //
      //     return BlocBuilder<UserTypeCubit, UserTypeState>(
      //       builder: (context, userTypeState) {
      //         return MaterialApp(
      //           title: 'Rental Service App',
      //           theme: AppTheme.lightTheme,
      //           // darkTheme: AppTheme.darkTheme,
      //           // themeMode: ThemeMode.system,
      //           home: const SplashWrapper(),
      //           onGenerateRoute: AppRoutes.generateRoute,
      //           routes: AppRoutes.getRoutes(),
      //         );
      //       },
      //     );
      //   },
      // ),
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


class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {

    // Remove splash only once after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<UserTypeCubit, UserTypeState>(
          builder: (context, userTypeState) {

            // Still waiting for data
            if (authState is AuthInitialState || userTypeState is UserTypeInitialState || userTypeState is UserTypeLoadingState) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            // Authenticated and user type known
            if (authState is Authenticated) {
              if (userTypeState is UserTypeLandLord) {
                return LandlordDashboard();// Replace with actual widget
              } else if (userTypeState is UserTypeTenant) {
                return TenantHomeScreen(); // Replace with actual widget
              } else {
                return SignInPage();
              }
            }

            // Unauthenticated
            return SignInPage(); // Replace with your login screen
          },
        );
      },
    );
  }
}