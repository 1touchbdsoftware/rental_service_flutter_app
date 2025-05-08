import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';
import 'package:rental_service/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'get_complains_state.dart';
import 'get_complains_state_cubit.dart';

class TenantDashboardContent extends StatelessWidget {
  const TenantDashboardContent({super.key});

  Future<void> _refreshComplains(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final agencyID = prefs.getString('agencyID') ?? '';
    final tenantID = prefs.getString('tenantID') ?? '';
    final landlordID = prefs.getString('landlordId') ?? '';
    final propertyID = prefs.getString('propertyID') ?? '';

    final params = GetComplainsParams(
      agencyID: agencyID,
      tenantID: tenantID,
      landlordID: landlordID,
      propertyID: propertyID,
      pageNumber: 1,
      pageSize: 15,
      isActive: true,
      flag: 'TENANT',
    );

    context.read<GetTenantComplainsCubit>().fetchComplains(
      useCase: sl<GetTenantComplainsUseCase>(),
      params: params,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'Tenant Complaints',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshComplains(context),
        child: BlocBuilder<GetTenantComplainsCubit, GetTenantComplainsState>(
          builder: (context, state) {
            if (state is GetTenantComplainsLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetTenantComplainsFailureState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.errorMessage}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _refreshComplains(context),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is GetTenantComplainsSuccessState) {
              return ListView.builder(
                itemCount: state.response.data.list.length,
                itemBuilder: (context, index) {
                  final complaint = state.response.data.list[index];
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(complaint.segmentName ?? 'No segment name'),
                      subtitle: Text(complaint.description ?? 'No description'),
                      trailing: Text(complaint.complainID ?? 'No ID'),
                      onTap: () {
                        // Handle complaint tap
                      },
                    ),
                  );
                },
              );
            }
            return const Center(child: Text('No complaints found', style: TextStyle(color: Colors.white)));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _refreshComplains(context),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}