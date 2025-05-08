import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state_cubit.dart';
import 'package:rental_service/presentation/dashboard/tenent_dashboard_content.dart';
import 'package:rental_service/service_locator.dart';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state_cubit.dart';
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
        final cubit = GetTenantComplainsCubit();
        _fetchComplains(cubit); // Fetch data as soon as cubit is created
        return cubit;
      },
      child: const TenantDashboardContent(),
    );
  }

  Future<void> _fetchComplains(GetTenantComplainsCubit cubit) async {
    print("Starting _fetchComplains");
    try {
      final prefs = await SharedPreferences.getInstance();
      print("SharedPreferences instance obtained");

      final agencyID = prefs.getString('agencyID') ?? '';
      final tenantID = prefs.getString('tenantID') ?? '';
      final landlordID = prefs.getString('landlordID') ?? '';
      final propertyID = prefs.getString('propertyID') ?? '';

      print("IDs retrieved - Agency: $agencyID, Tenant: $tenantID, Landlord: $landlordID, Property: $propertyID");

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

      print("Params created, getting usecase");
      final useCase = sl<GetTenantComplainsUseCase>();
      print("UseCase retrieved from service locator");

      print("Calling cubit.fetchComplains");
      cubit.fetchComplains(
        useCase: useCase,
        params: params,
      );
      print("cubit.fetchComplains called");
    } catch (e) {
      print("Error in _fetchComplains: $e");
    }
  }
}