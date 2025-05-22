// lib/presentation/dashboard/complains_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/user/user_info_model.dart';
import '../dashboard/bloc/user_info_cubit.dart';
import 'bloc/get_complains_state_cubit.dart';
import 'complains_pending_list_conent.dart';

class ComplainsListScreen extends StatelessWidget {
  const ComplainsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserInfoCubit(UserInfoModel.empty())..loadUserInfo(),
        ),
        BlocProvider(
          create: (_) => GetComplainsCubit(),
        ),
      ],
      child: const ComplainsListContent(),
    );
  }
}


