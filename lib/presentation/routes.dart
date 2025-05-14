// lib/core/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/presentation/create_complain_screen.dart';
import 'package:rental_service/presentation/tenant_complain_list/complain_list_screen.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/tenant/TenantDashboard.dart';

class AppRoutes {
  static const String signIn = '/sign-in';
  static const String landlordDashboard = '/landlord-dashboard';
  static const String tenantDashboard = '/tenant-dashboard';
  static const String complainListScreen = '/complain-list-screen';
  static const String createComplainScreen = '/create-complain-screen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case landlordDashboard:
        return MaterialPageRoute(builder: (_) => const LandlordDashboard());
      case tenantDashboard:
        return MaterialPageRoute(builder: (_) => const TenantDashboardScreen());
      case complainListScreen:
        return MaterialPageRoute(builder: (_) => const ComplainsListScreen());

      case createComplainScreen:
        return MaterialPageRoute(builder: (_) => const CreateComplainScreen());


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
      createComplainScreen: (context) => CreateComplainScreen(),
    };
  }
}