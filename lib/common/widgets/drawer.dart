import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/common/bloc/button/button_state_cubit.dart';
import 'package:rental_service/domain/usecases/logout_usecase.dart';

import '../../service_locator.dart';

Widget buildAppDrawer(BuildContext context, String username, String dashboardTitle) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        // Image & Dashboard Title Section
        Container(
          color: Colors.blue,
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: Image.asset(
                  'asset/images/pro_matrix_logo.png', // Replace with your actual image path
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 10),
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

        // Complains List
        ListTile(
          leading: Icon(Icons.list, color: Colors.white),
          title: Text('Complains List',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        Divider(),

        // Profile with username
        ListTile(
          leading: Icon(Icons.person, color: Colors.white),
          title: Text(username,  style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        // Settings
        ListTile(
          leading: Icon(Icons.settings, color: Colors.white),
          title: Text('Settings',  style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
          onTap: () {
            Navigator.pop(context);
          },
        ),

        // Logout
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is UnAuthenticated) {
              // Close the drawer
              // Navigator.pop(context);
              // You might want to navigate to login screen here if not handled by main BlocBuilder
            } else if (state is AuthErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: Text('Logout', style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
            onTap: () {
              context.read<AuthCubit>().logOut(usecase: sl<LogoutUseCase>());
            },
          ),
        ),
      ],
    ),
  );
}
