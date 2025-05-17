import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/domain/usecases/logout_usecase.dart';

import '../../service_locator.dart';
Widget buildAppDrawer(BuildContext context, String username, String dashboardTitle) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header
        Container(
          color: Colors.white,
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),

        // ✅ Home
        ListTile(
          leading: Icon(Icons.home, color: Colors.white),
          title: Text('Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.pop(context);

            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

          },
        ),

        // Complains List
        ListTile(
          leading: Icon(Icons.list, color: Colors.white),
          title: Text('Complains List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        Divider(),

        // Profile
        ListTile(
          leading: Icon(Icons.person, color: Colors.white),
          title: Text(username, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        // Settings
        ListTile(
          leading: Icon(Icons.settings, color: Colors.white),
          title: Text('Settings', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        // ✅ Logout with Confirmation
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
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            onTap: () {
              _showLogoutConfirmation(context);
            },
          ),
        ),
      ],
    ),
  );
}

void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Confirm Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          ElevatedButton(
            child: Text("Logout"),
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

