import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/dashboard/get_complains_state_cubit.dart';
import 'package:rental_service/presentation/dashboard/complains_list_conent.dart';
import 'package:rental_service/domain/usecases/get_complains_usecase.dart';
import 'package:rental_service/data/model/get_complain_req_params.dart';
import 'package:rental_service/presentation/dashboard/tenant/tenent_home_screen.dart';
import 'package:rental_service/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/bloc/auth/auth_cubit.dart';

class TenantDashboardScreen extends StatelessWidget {
  const TenantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("Building TenantDashboardScreen");
    return
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              final cubit = GetTenantComplainsCubit();
              fetchComplains(cubit);
              return cubit;
            },
          ),
          // This makes the existing AuthCubit available to children
          BlocProvider.value(
            value: BlocProvider.of<AuthCubit>(context),
          ),
        ],
        child: const TenantHomeScreen(),
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