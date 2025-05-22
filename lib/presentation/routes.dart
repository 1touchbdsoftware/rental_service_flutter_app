// lib/core/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:rental_service/domain/entities/complain_entity.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/presentation/create_complain/create_complain_screen.dart';
import 'package:rental_service/presentation/tenant_complain_list/complain_declined_list_screen.dart';
import 'package:rental_service/presentation/tenant_complain_list/complain_pending_list_screen.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/tenant/TenantDashboard.dart';
import 'package:rental_service/presentation/tenant_complain_list/complain_solved_list_screen.dart';
import 'package:rental_service/presentation/edit_complain/edit_complain_screen.dart';

import '../data/model/complain/ComplainModel.dart';
import 'landlord_complain_list/landlord_issue_list.dart';

class AppRoutes {
  static const String signIn = '/sign-in';
  static const String landlordDashboard = '/landlord-dashboard';
  static const String tenantDashboard = '/technician-dashboard';
  static const String complainListScreen = '/complain-list-screen';
  static const String complainCompletedListScreen = '/complain-completed-list-screen';
  static const String complainDeclinedListScreen = '/complain-declined-list-screen';
  static const String createComplainScreen = '/create_complain-screen';

  static const String landlordIssueListScreen = '/landlord-issues-screen';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case landlordDashboard:
        return MaterialPageRoute(builder: (_) => const LandlordDashboard());
      case tenantDashboard:
        return MaterialPageRoute(builder: (_) => const TenantDashboardScreen());
      case createComplainScreen:
        return MaterialPageRoute(builder: (_) => const CreateComplainScreen());
      case complainListScreen:
        return MaterialPageRoute(builder: (_) => const ComplainsListScreen());
      case complainCompletedListScreen:
        return MaterialPageRoute(builder: (_) => const ComplainsCompletedListScreen());
      case complainDeclinedListScreen:
        return MaterialPageRoute(builder: (_) => const ComplainsDeclinedListScreen());
      case landlordIssueListScreen:
        return MaterialPageRoute(builder: (_) => const LandlordIssueListScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      signIn: (context) => SignInPage(),
      landlordDashboard: (context) => const LandlordDashboard(),
      tenantDashboard: (context) => const TenantDashboardScreen(),
      complainListScreen: (context) => ComplainsListScreen(),
      complainCompletedListScreen: (context) => ComplainsCompletedListScreen(),
      complainDeclinedListScreen: (context) => ComplainsDeclinedListScreen(),
      createComplainScreen: (context) => CreateComplainScreen(),
      landlordIssueListScreen: (context) => LandlordIssueListScreen(),


    };
  }
}