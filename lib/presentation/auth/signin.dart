import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/button/button_state.dart';
import 'package:rental_service/common/bloc/button/button_state_cubit.dart';
import 'package:rental_service/data/model/user/signin_req_params.dart';
import 'package:rental_service/data/model/user/user_info_model.dart';
import 'package:rental_service/domain/usecases/signin_usecase.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_info_cubit.dart';
import 'package:rental_service/presentation/dashboard/landloard/LandlordDashboard.dart';
import 'package:rental_service/presentation/dashboard/bloc/user_type_cubit.dart';
import 'package:rental_service/presentation/password/password_reset_screen.dart';
import '../../core/constants/app_colors.dart';
import '../../service_locator.dart';
import '../dashboard/tenant/TenantDashboard.dart';
import '../password/bloc/default_password_state.dart';
import '../password/bloc/default_password_cubit.dart';
import '../widgets/loading.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent resizing when keyboard appears
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ButtonStateCubit()),
          BlocProvider(create: (context) => UserTypeCubit()),
          BlocProvider(create: (context) => DefaultPasswordCubit()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ButtonStateCubit, ButtonState>(
              listener: (context, state) async {
                print("ButtonState changed: ${state.runtimeType}");
                if (state is ButtonSuccessState) {
                  print("Login successful - fetching user type");
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login successful!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                    await context
                        .read<DefaultPasswordCubit>()
                        .checkIfDefaultPassword();
                  } catch (e) {
                    print("Error fetching user type: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Login successful but failed to load dashboard: $e',
                        ),
                        backgroundColor: Colors.orange,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                } else if (state is ButtonFailureState) {
                  print("Login failed: ${state.errorMessage}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Could not Log you in ${state.errorMessage}",
                      ),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else if (state is ButtonLoadingState) {
                  print("Login in progress...");
                }
              },
            ),
            BlocListener<DefaultPasswordCubit, DefaultPasswordState>(
              listener: (context, state) {
                if (state is IsDefaultPasswordState) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                } else if (state is NotDefaultPasswordState) {
                  print("Password is not default - fetching user type");
                  context.read<UserTypeCubit>().getUserType();
                }
              },
            ),
            BlocListener<UserTypeCubit, UserTypeState>(
              listener: (context, state) {
                print("UserTypeState changed: ${state.runtimeType}");
                if (state is UserTypeLandLord) {
                  print("Navigating to Landlord Dashboard");
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LandlordDashboard(),
                      ),
                    );
                  });
                } else if (state is UserTypeTenant) {
                  print("Navigating to Tenant Dashboard");
                  Future.microtask(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TenantDashboardScreen(),
                      ),
                    );
                  });
                } else if (state is UserTypeError) {
                  print("UserType error: ${state.toString()}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Failed to determine user type. Please try logging in again.',
                      ),
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
        _buildBackground(context),
        _buildFormContent(context),
        _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('asset/images/building.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black87,
            BlendMode.darken,
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
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
          style: TextStyle(color: Colors.white70, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: _usernameController,
      keyboardType: TextInputType.text,
      autocorrect: false,
      decoration: const InputDecoration(
        labelText: 'Username',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(Icons.person_rounded, color: Colors.lightBlue),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
    );
  }

  bool _obscurePassword = true;

  Widget _buildPasswordField() {
    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock, color: Colors.lightBlue),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.lightBlue),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildRememberForgotRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // const Row(
        //   children: [
        //     Text('Remember me', style: TextStyle(color: Colors.white)),
        //   ],
        // ),
        TextButton(
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const ChangePasswordScreen(),
            //   ),
            // );
          },
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
          onPressed: state is ButtonLoadingState ? null : () => _handleLogin(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.logInButton,
            padding: const EdgeInsets.symmetric(vertical: 15),
            minimumSize: const Size(double.infinity, 50), // Width fills parent, min height 50
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: state is ButtonLoadingState
              ? const AdaptiveLoading()
              : const Text('LOGIN', style: TextStyle(fontSize: 18, color: Colors.white,)),
        );
      },
    );
  }

  void _handleLogin(BuildContext context) {
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
          color: Colors.black.withValues(alpha: 0.5),
        ) : const SizedBox.shrink();
      },
    );
  }
}