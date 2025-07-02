import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/core/constants/app_colors.dart';
import 'package:rental_service/data/model/password/change_password_request.dart';
import 'package:rental_service/presentation/password/save_change_pass_cubit.dart';
import 'package:rental_service/presentation/password/save_change_pass_state.dart';

import 'package:rental_service/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/loading.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmNewPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => ChangePasswordCubit(),
        child: BlocListener<ChangePasswordCubit, ChangePasswordState>(
          listener: (context, state) {
            if (state is ChangePasswordSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message ?? 'Password changed successfully!'),
                  duration: const Duration(seconds: 2),
                ),
              );
              Navigator.pop(context);
            } else if (state is ChangePasswordFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
          child: _buildPageContent(context),
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroundWithForm(context),
        _buildLoadingOverlay(context),
      ],
    );
  }

  Widget _buildBackgroundWithForm(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: _buildBackgroundDecoration(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildFormContent(context),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      image: DecorationImage(
        image: const AssetImage('asset/images/building.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withAlpha(200),
          BlendMode.darken,
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 100),
          _buildLogo(),
          const SizedBox(height: 30),
          _buildTitleText(),
          const SizedBox(height: 30),
          _buildCurrentPasswordField(),
          const SizedBox(height: 20),
          _buildNewPasswordField(),
          const SizedBox(height: 20),
          _buildConfirmNewPasswordField(),
          const SizedBox(height: 30),
          _buildChangePasswordButton(context),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      height: 70,
      width: 100,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/images/pro_matrix_logo.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return const Column(
      children: [
        Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Enter your current password and new password',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: _currentPasswordController,
          obscureText: _obscureCurrentPassword,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            labelText: 'Current Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.lightBlue),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your current password';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildNewPasswordField() {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: _newPasswordController,
          obscureText: _obscureNewPassword,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            labelText: 'New Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.lightBlue),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your new password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildConfirmNewPasswordField() {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: _confirmNewPasswordController,
          obscureText: _obscureConfirmNewPassword,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            labelText: 'Confirm New Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.lightBlue),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmNewPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your new password';
            }
            if (value != _newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildChangePasswordButton(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is ChangePasswordLoading
              ? null
              : () => _handleChangePassword(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.logInButton,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: state is ChangePasswordLoading
              ? const AdaptiveLoading()
              : const Text(
            'CHANGE PASSWORD',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  void _handleChangePassword(BuildContext context) async {
    if (_currentPasswordController.text.trim().isEmpty ||
        _newPasswordController.text.trim().isEmpty ||
        _confirmNewPasswordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill out all fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New password and confirmation do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 8 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? '';

    final changePasswordRequest = ChangePasswordRequest(
      currentPassword: _currentPasswordController.text.trim(),
      password: _newPasswordController.text.trim(),
      userName: userName,
    );

    context.read<ChangePasswordCubit>().changePassword(changePasswordRequest);
  }

  Widget _buildLoadingOverlay(BuildContext context) {
    return BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
      builder: (context, state) {
        return state is ChangePasswordLoading
            ? Container(
          color: Colors.black.withOpacity(0.5),
          child: const Center(
            child: AdaptiveLoading(),
          ),
        )
            : const SizedBox.shrink();
      },
    );
  }
}