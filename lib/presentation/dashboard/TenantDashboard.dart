import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state_cubit.dart';
import 'package:rental_service/presentation/dashboard/tenent_dashboard_content.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building TenantDashboardScreen");
    return BlocProvider(
      create: (context) {
        print("Creating GetTenantComplainsCubit");
        // Create cubit with injected useCase
        final cubit = GetTenantComplainsCubit(useCase: sl<GetTenantComplainsUseCase>());
        // Fetch data as soon as cubit is created
        fetchComplains(cubit);
        return cubit;
      },
      child: const TenantDashboardContent(),
    );
  }

  Future<void> fetchComplains(GetTenantComplainsCubit cubit) async {
    print("Starting fetchComplains in TenantDashboardScreen");
    try {
      final prefs = await SharedPreferences.getInstance();
      print("SharedPreferences instance obtained");

      final agencyID = prefs.getString('agencyID') ?? '';
      final tenantID = prefs.getString('tenantID') ?? '';
      final landlordID = prefs.getString('landlordID') ?? '';
      final propertyID = prefs.getString('propertyID') ?? '';

      print("IDs retrieved:");
      print("- Agency: '$agencyID'");
      print("- Tenant: '$tenantID'");
      print("- Landlord: '$landlordID'");
      print("- Property: '$propertyID'");

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

      print("Params created, calling cubit.fetchComplains");
      await cubit.fetchComplains(params: params);
      print("cubit.fetchComplains completed");
    } catch (e) {
      print("Error in fetchComplains: $e");
    }
  }
}