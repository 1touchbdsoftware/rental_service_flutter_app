import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';


import 'package:rental_service/core/theme/app_theme.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_type_cubit.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/tenant/tenent_home_screen.dart';
import 'package:rental_service/presentation/routes.dart';
import 'package:rental_service/service_locator.dart';

void main() {
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
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {

          return BlocBuilder<UserTypeCubit, UserTypeState>(
            builder: (context, userTypeState) {
              return MaterialApp(
                title: 'Rental Service App',
                theme: AppTheme.lightTheme,
                // darkTheme: AppTheme.darkTheme,
                // themeMode: ThemeMode.system,
                home: const SplashWrapper(),
                onGenerateRoute: AppRoutes.generateRoute,
                routes: AppRoutes.getRoutes(),
              );
            },
          );
        },
      ),
    );
  }

  // String _getInitialRoute(AuthState authState, UserTypeState userTypeState) {
  //   if (authState is Authenticated) {
  //     if (userTypeState is UserTypeLandLord) {
  //       return AppRoutes.landlordDashboard;
  //     } else if (userTypeState is UserTypeTenant) {
  //       return AppRoutes.tenantDashboard;
  //     } else {
  //       // If authenticated but user type not determined yet
  //       return AppRoutes.signIn; // Or a loading route if you prefer
  //     }
  //   } else {
  //     return AppRoutes.signIn;
  //   }
  // }



}

class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  @override
  Widget build(BuildContext context) {
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