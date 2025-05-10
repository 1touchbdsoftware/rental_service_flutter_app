import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/common/bloc/button/button_state_cubit.dart';
import 'package:rental_service/core/theme/app_theme.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/presentation/dashboard/LandlordDashboard.dart';
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
        BlocProvider(create: (context) => ButtonStateCubit()),
        BlocProvider(create: (context) => AuthCubit()..appStarted()),
      ],
      child: MaterialApp(
        title: 'Rental Service App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is Authenticated) {
              return Landlorddashboard();
            } else if (state is UnAuthenticated) {
              return SignInPage();
            } else if (state is AuthErrorState) {
              // You might want to show an error screen or just go to login
              return SignInPage();
            }
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        ),
      ),
    );
  }
}