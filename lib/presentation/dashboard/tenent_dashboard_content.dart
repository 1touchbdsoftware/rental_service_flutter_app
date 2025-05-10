import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/widgets/drawer.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state_cubit.dart';
import 'package:rental_service/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/bloc/auth/auth_cubit.dart';
import '../auth/signin.dart';

class TenantDashboardContent extends StatelessWidget {
  const TenantDashboardContent({super.key});

  Future<void> refreshComplains(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final agencyID = prefs.getString('agencyID') ?? '';
      final tenantID = prefs.getString('tenantID') ?? '';
      final landlordID = prefs.getString('landlordID') ?? '';
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

      await context.read<GetTenantComplainsCubit>().fetchComplains(
          params: params);
    } catch (e) {
      print("Error in refreshComplains: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          // Navigate to login screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SignInPage()),
                (Route<dynamic> route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          title: const Text(
            'Tenant Complaints',
            style: TextStyle(color: Colors.black),
          ),

        ),
        drawer: buildAppDrawer(context, 'John Doe', 'Tenant Dashboard'),
        body: RefreshIndicator(
          onRefresh: () => refreshComplains(context),
          child: BlocBuilder<GetTenantComplainsCubit, GetTenantComplainsState>(
            builder: (context, state) {
              if (state is GetTenantComplainsLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
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
                        onPressed: () => refreshComplains(context),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is GetTenantComplainsSuccessState) {
                final complaints = state.response.data.list;

                if (complaints.isEmpty) {
                  return const Center(
                    child: Text(
                      'No complaints found',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final complaint = complaints[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(complaint.segmentName ?? 'No segment name'),
                        subtitle: Text(
                            complaint.description ?? 'No description'),
                        trailing: Text(complaint.complainID ?? 'No ID'),
                        onTap: () {
                          // Handle complaint tap
                        },
                      ),
                    );
                  },
                );
              }

              // Initial state or unexpected state
              return const Center(
                child: Text(
                  'No complaints found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => refreshComplains(context),
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}