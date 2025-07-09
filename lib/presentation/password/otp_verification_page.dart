import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/common/bloc/button/button_state.dart';
import 'package:rental_service/common/bloc/button/button_state_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/loading.dart';
import '../widgets/auth_widgets/build_background.dart';
import '../widgets/auth_widgets/build_logo.dart';
import '../widgets/auth_widgets/build_welcome_text.dart';
import 'bloc/forgot_password_cubit.dart';
import 'bloc/forgot_request_state.dart';


class OTPVerificationPage extends StatefulWidget {
  OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ForgotPasswordCubit()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ForgotPasswordSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('OTP Verified successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else if (state is ForgotPasswordFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: ${state.errorMessage}"),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
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
        buildBackground(context),
        _buildFormContent(context),
        _buildLoadingOverlay(),
      ],
    );
  }

  Widget _buildFormContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 100,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            buildLogo(),
            const SizedBox(height: 30),
            buildWelcomeText(),
            const SizedBox(height: 20),
            _buildOTPField(),
            const SizedBox(height: 20),
            _buildResendOTPButton(context),
            const SizedBox(height: 20),
            _buildVerifyOTPButton(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildWelcomeText() {
    return FutureBuilder<String>(
      future: _getEmailFromSharedPrefs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return Column(
            children: [
              Text(
                'OTP sent to: ${snapshot.data}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter the OTP sent to your email',
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          );
        } else {
          return const Text(
            'Error loading email',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  Future<String> _getEmailFromSharedPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email') ?? 'No email found';
  }

  Widget _buildOTPField() {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: _otpController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      decoration: const InputDecoration(
        labelText: 'Enter OTP',
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.lightBlue),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.lightBlue),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter the OTP';
        }
        return null;
      },
    );
  }

  Widget _buildResendOTPButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Trigger resend OTP functionality here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP has been resent!')),
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        'Resend OTP',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }


  Widget _buildVerifyOTPButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Verify OTP
        if (_otpController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter the OTP')),
          );
        } else {
          // Call cubit to verify OTP
          context.read<ForgotPasswordCubit>().requestPasswordReset(_otpController.text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.logInButton,
        padding: const EdgeInsets.symmetric(vertical: 15),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: const Text(
        'Verify OTP',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
      builder: (context, state) {
        return state is ForgotPasswordLoading
            ? Container(
          color: Colors.black.withOpacity(0.5),
        )
            : const SizedBox.shrink();
      },
    );
  }
}
