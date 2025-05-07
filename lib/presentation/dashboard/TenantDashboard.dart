import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_cubit.dart';

import '../../core/theme/app_theme.dart';

class TenantDashboard extends StatelessWidget {
  const TenantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = UsernameCubit();
        cubit.loadUsername();
        return cubit;
      },
      child: Scaffold(
        backgroundColor: AppColors.primary, // Body background
        appBar: AppBar(
          backgroundColor: AppColors.primary, // AppBar background
          title: BlocBuilder<UsernameCubit, String?>(
            builder: (context, username) {
              return Text(
                "Tenant: ${username ?? 'Loading...'}",
                style: TextStyle(color: AppColors.onPrimary),
              );
            },
          ),
        ),
        body: const Center(
          child: Text("Dashboard Content"),
        ),
      ),
    );
  }
}