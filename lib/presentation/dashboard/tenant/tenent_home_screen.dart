import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/auth/auth_cubit.dart';
import 'package:rental_service/common/widgets/drawer.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/presentation/auth/signin.dart';

class TenantHomeScreen extends StatelessWidget {
  const TenantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
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
            'Tenant Dashboard',
            style: TextStyle(color: Colors.black),
          ),
        ),
        drawer: buildAppDrawer(context, 'John Doe', 'Tenant Dashboard'),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Image at center vertical
                const Spacer(flex: 2),
                _buildProfileImage(),
                const SizedBox(height: 20),

                // Username text
                _buildUserNameText(),
                const Spacer(),

                // Three big buttons
                _buildActionButton(
                  context,
                  icon: Icons.add_circle_outline,
                  text: 'Create Complaint',
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.pushNamed(context, '/create-complain-screen');
                  },
                ),
                const SizedBox(height: 20),

                _buildActionButton(
                  context,
                  icon: Icons.pending_actions,
                  text: 'Complaint Pending List',
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/complain-list-screen');
                  },
                ),
                const SizedBox(height: 20),

                _buildActionButton(
                  context,
                  icon: Icons.check_circle_outline,
                  text: 'Complaint Solved List',
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pushNamed(context, '/solved-complaints');
                  },
                ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Image.asset(
        'asset/images/pro_matrix_logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildUserNameText() {
    return const Text(
      'John Doe',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String text,
        required Color color,
        required VoidCallback onPressed,
      }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            const SizedBox(width: 15),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}