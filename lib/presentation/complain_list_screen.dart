// lib/presentation/dashboard/complains_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state_cubit.dart';
import 'package:rental_service/service_locator.dart';

import '../domain/usecases/get_complains_usecase.dart';
import 'dashboard/complains_list_conent.dart';

class ComplainsListScreen extends StatelessWidget {
  const ComplainsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetTenantComplainsCubit(useCase: sl<GetTenantComplainsUseCase>()),
      child: const ComplainsListContent(),
    );
  }
}
