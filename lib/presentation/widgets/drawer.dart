import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/domain/usecases/logout_usecase.dart';

import '../../service_locator.dart';

Widget buildAppDrawer(BuildContext context, String username,
    String dashboardTitle, String userType) {
  // Get theme colors from the current theme
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  return Drawer(
    backgroundColor: colorScheme.surface,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header
        Container(
          color: colorScheme.surface,
          child: Column(
            children: [
              SizedBox(height: 50),
              SizedBox(
                width: 200,
                height: 100,
                child: Image.asset(
                  'asset/images/pro_matrix_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                dashboardTitle,
                style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),

        // Home with User Type-based navigation
        ListTile(
          leading: Icon(Icons.home, color: colorScheme.primary),
          title: Text(
            'Home',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context); // Close drawer

            // Navigate based on user type
            if (userType == "LANDLORD") {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/landlord-dashboard',
                      (route) => false
              );
            } else if (userType == "TENANT") {
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/tenant-dashboard',
                      (route) => false
              );
            }
          },
        ),

        // Complaints List
        ListTile(
          leading: Icon(Icons.list, color: colorScheme.primary),
          title: Text(
            'Complains List',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            // Navigate based on user type
            if (userType == "LANDLORD") {
              print("LANDLORD ROUTE CALLED");
              Navigator.pushNamed(context, '/landlord-issues-screen');
            } else if (userType == "TENANT") {
              Navigator.pushNamed(context, '/complain-list-screen');
            }
          },
        ),

        Divider(color: colorScheme.outline),

        // Profile
        ListTile(
          leading: Icon(Icons.person, color: colorScheme.primary),
          title: Text(
            username,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            // Navigate to profile based on user type
            if (userType == "LANDLORD") {
              Navigator.pushNamed(context, '/landlord-profile');
            } else if (userType == "TENANT") {
              Navigator.pushNamed(context, '/tenant-profile');
            }
          },
        ),

        // Settings
        ListTile(
          leading: Icon(Icons.settings, color: colorScheme.primary),
          title: Text(
            'Settings',
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/settings');
          },
        ),

        // Logout with Confirmation
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              // Optional: Navigate to login if not handled elsewhere
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: ListTile(
            leading: Icon(Icons.logout, color: colorScheme.error),
            title: Text(
              'Logout',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              showLogoutConfirmation(context);
            },
          ),
        ),
      ],
    ),
  );
}

void showLogoutConfirmation(BuildContext context) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: colorScheme.error,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              "Confirm Logout",
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to log out of your account?",
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Cancel",
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Logout",
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
              context.read<AuthCubit>().logOut(usecase: sl<LogoutUseCase>());
            },
          ),
        ],
      );
    },
  );
}