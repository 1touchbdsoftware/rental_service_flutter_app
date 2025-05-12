// lib/core/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:rental_service/presentation/auth/signin.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/tenant/TenantDashboard.dart';

class AppRoutes {
  static const String signIn = '/sign-in';
  static const String landlordDashboard = '/landlord-dashboard';
  static const String tenantDashboard = '/tenant-dashboard';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => SignInPage());
      case landlordDashboard:
        return MaterialPageRoute(builder: (_) => const Landlorddashboard());
      case tenantDashboard:
        return MaterialPageRoute(builder: (_) => const TenantDashboardScreen());
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
      landlordDashboard: (context) => const Landlorddashboard(),
      tenantDashboard: (context) => const TenantDashboardScreen(),
    };
  }
}