import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/button/button_state.dart';
import 'package:rental_service/common/bloc/button/button_state_cubit.dart';
import 'package:rental_service/common/widgets/loading.dart';
import 'package:rental_service/data/model/signin_req_params.dart';
import 'package:rental_service/domain/usecases/signin.dart';
import 'package:rental_service/presentation/dashboard/LandlordDashboard.dart';

import '../../service_locator.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: _handleStateChanges,
          child: _buildPageContent(context),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ButtonState state) {
    if (state is ButtonSuccessState) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Landlorddashboard()),
      );
    } else if (state is ButtonFailureState) {
      var snackBar = SnackBar(content: Text(state.errorMessage));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
          Colors.black.withAlpha(100),
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
          const SizedBox(height: 20),
          _buildLogo(),
          const SizedBox(height: 30),
          _buildWelcomeText(),
          const SizedBox(height: 30),
          _buildUsernameField(),
          const SizedBox(height: 20),
          _buildPasswordField(),
          const SizedBox(height: 10),
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
      height: 100,
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
      controller: _usernameController,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(
        labelText: 'Username',
        prefixIcon: Icon(Icons.email),
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
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
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
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
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
    context.read<ButtonStateCubit>().execute(
      usecase: sl<SigninUseCase>(),
      params: SignInReqParams(
        userName: _usernameController.text,
        password: _passwordController.text,
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