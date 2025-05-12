import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';


import 'package:rental_service/core/theme/app_theme.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_type_cubit.dart';
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
        BlocProvider(create: (context) => UserTypeCubit()),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return BlocBuilder<UserTypeCubit, UserTypeState>(
            builder: (context, userTypeState) {
              return MaterialApp(
                title: 'Rental Service App',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: ThemeMode.system,
                initialRoute: _getInitialRoute(authState, userTypeState),
                onGenerateRoute: AppRoutes.generateRoute,
                routes: AppRoutes.getRoutes(),
              );
            },
          );
        },
      ),
    );
  }

  String _getInitialRoute(AuthState authState, UserTypeState userTypeState) {
    if (authState is Authenticated) {
      if (userTypeState is UserTypeLandLord) {
        return AppRoutes.landlordDashboard;
      } else if (userTypeState is UserTypeTenant) {
        return AppRoutes.tenantDashboard;
      } else {
        // If authenticated but user type not determined yet
        return AppRoutes.signIn; // Or a loading route if you prefer
      }
    } else {
      return AppRoutes.signIn;
    }
  }
}