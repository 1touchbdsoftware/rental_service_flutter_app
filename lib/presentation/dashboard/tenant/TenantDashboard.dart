import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/dashboard/tenant/tenent_home_screen.dart';
import '../../../common/bloc/auth/auth_cubit.dart';

class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
        providers: [
          // This makes the existing AuthCubit available to children
          BlocProvider.value(
            value: BlocProvider.of<AuthCubit>(context),
          ),
        ],
        child: const TenantHomeScreen(),
      );

  }

}