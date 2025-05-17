import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';

import '../../widgets/drawer.dart';
import '../bloc/user_cubit.dart';

class LandlordDashboard extends StatelessWidget {
  const LandlordDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: BlocBuilder<UserInfoCubit, UserInfoModel>(
            builder: (context, state) {
              return Text(
                "Landlord: ${state.userName}",
                style: TextStyle(color: AppColors.onPrimary),
              );
            },
          ),
        ),
        drawer: BlocBuilder<UserInfoCubit, UserInfoModel>(
          builder: (context, userInfo) {
            return buildAppDrawer(
                context,
                userInfo.landlordName?? "",
                'Landlord Dashboard'
            );
          },
        ),
        body: const Center(
          child: Text("Landlord Dashboard Content"),
        ),
      ),
    );
  }
}