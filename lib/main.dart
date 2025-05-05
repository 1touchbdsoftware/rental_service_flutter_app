import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      AuthCubit()
        ..appStarted(),
      child: MaterialApp(
        title: 'Rental Service App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if(state is Authenticated){
              return Landlorddashboard();
            }else{
              return SignInPage();
            }
            // return Container(); display splash or other page

          },
        ),
      ),
    );
  }
}
