import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/button/button_state.dart';
import 'package:rental_service/common/bloc/button/button_state_cubit.dart';

import 'package:rental_service/data/model/user/signin_req_params.dart';
import 'package:rental_service/domain/usecases/signin_usecase.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_type_cubit.dart';

import '../../core/constants/app_colors.dart';
import '../../service_locator.dart';
import '../dashboard/tenant/TenantDashboard.dart';
import '../widgets/loading.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ButtonStateCubit()),
          BlocProvider(create: (context) => UserTypeCubit()),
        ],
        child: MultiBlocListener(
          listeners: [
            // Primary listener for login success/failure
            BlocListener<ButtonStateCubit, ButtonState>(
              listener: (context, state) async {
                print("ButtonState changed: ${state.runtimeType}");

                if (state is ButtonSuccessState) {
                  print("Login successful - fetching user type");

                  try {
                    // Show loading indicator for user type fetch
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login successful!'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Fetch user type with proper error handling
                    await context.read<UserTypeCubit>().getUserType();

                  } catch (e) {
                    print("Error fetching user type: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login successful but failed to load dashboard: $e'),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                } else if (state is ButtonFailureState) {
                  print("Login failed: ${state.errorMessage}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Could not Log you in ${state.errorMessage}"),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else if (state is ButtonLoadingState) {
                  print("Login in progress...");
                }
              },
            ),

            // Listener for user type changes with better error handling
            BlocListener<UserTypeCubit, UserTypeState>(
              listener: (context, state) {
                print("UserTypeState changed: ${state.runtimeType}");

                if (state is UserTypeLandLord) {
                  print("Navigating to Landlord Dashboard");
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const LandlordDashboard()),
                    );
                  });
                } else if (state is UserTypeTenant) {
                  print("Navigating to Tenant Dashboard");
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TenantDashboardScreen()),
                    );
                  });
                } else if (state is UserTypeError) {
                  print("UserType error: ${state.toString()}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to determine user type. Please try logging in again.'),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'Retry',
                        onPressed: () {
                          context.read<UserTypeCubit>().getUserType();
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
          child: _buildPageContent(context),
        ),
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroundWithForm(context),
        _buildLoadingOverlay(),
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
          _buildWelcomeText(),
          const SizedBox(height: 30),
          _buildUsernameField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 30),
          _buildRememberForgotRow(),
          const SizedBox(height: 20),
          _buildLoginButton(context),
          const SizedBox(height: 30),
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

  Widget _buildWelcomeText() {
    return const Column(
      children: [
        Text(
          'Welcome',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Sign in to continue',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: _usernameController,
      keyboardType: TextInputType.text, // Allows all characters
      autocorrect: false, // Disables iOS auto-correction
      decoration: const InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(Icons.email, color: Colors.lightBlue),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock, color: Colors.lightBlue),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            Text(
              'Remember me',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is ButtonLoadingState
              ? null
              : () => _handleLogin(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.logInButton,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: state is ButtonLoadingState
              ? const AdaptiveLoading()
              : const Text(
            'LOGIN',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }

  void _handleLogin(BuildContext context) {
    // Add validation
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username and password'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print("Attempting login with username: ${_usernameController.text}");

    context.read<ButtonStateCubit>().execute(
      usecase: sl<SigninUseCase>(),
      params: SignInReqParams(
        userName: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return BlocBuilder<ButtonStateCubit, ButtonState>(
      builder: (context, state) {
        return state is ButtonLoadingState
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