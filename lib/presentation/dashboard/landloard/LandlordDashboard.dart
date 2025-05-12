import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_cubit.dart';

import '../../../common/widgets/drawer.dart';
import '../../../core/theme/app_theme.dart';

class Landlorddashboard extends StatelessWidget {
  const Landlorddashboard( {super.key});

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
                "Landlord: ${username ?? 'Loading...'}",
                style: TextStyle(color: AppColors.onPrimary),
              );
            },
          ),
        ),
        drawer: buildAppDrawer(context, 'John Doe', 'Landlord Dashboard'),
        body: const Center(
          child: Text("Land Dashboard Content"),
        ),
      ),
    );
  }
}