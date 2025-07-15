import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_service/presentation/password/bloc/forgot_password_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/auth_widgets/build_background.dart';
import '../widgets/auth_widgets/build_logo.dart';
import 'bloc/verify_otp_cubit.dart';
import 'bloc/verify_otp_state.dart';

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
      body: BlocProvider(
        create: (context) => VerifyOtpCubit(),
        child: MultiBlocListener(
          listeners: [
            BlocListener<VerifyOtpCubit, VerifyOtpState>(
              listener: (context, state) {
                if (state is VerifyOtpFailure) {
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
    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      builder: (context, state) {
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
                if (state is VerifyOtpSuccess) ...[
                  _buildSuccessUI(),
                ] else if (state is VerifyOtpLoading) ...[
                  _buildLoadingState(),
                ] else ...[
                  buildWelcomeText(),
                  const SizedBox(height: 20),
                  _buildOTPField(),
                  const SizedBox(height: 20),
                  _buildResendOTPButton(context),
                  const SizedBox(height: 20),
                  _buildVerifyOTPButton(context),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuccessUI() {
    return Column(
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 20),
        const Text(
          'Verification Successful!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        FutureBuilder<String>(
          future: _getEmailFromSharedPrefs(),
          builder: (context, snapshot) {
            return Column(
              children: [
                 Text(
                  'A default password has been sent to:\n ${snapshot.data}',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (snapshot.hasData) {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: '',
                      );
                      launchUrl(emailLaunchUri);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                       'Open Mail',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () {
            // Navigate to login page or handle login
            Navigator.pushNamed(context, '/sign-in');
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
            'Login',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
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
              GestureDetector(
                onTap: () {
                  final email = snapshot.data!;
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: '',
                  );
                  launchUrl(emailLaunchUri);
                },
                child: Text(
                  'OTP sent to:\n ${snapshot.data}➡️',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
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
    return _ResendOTPButton(
      onResend: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String email = prefs.getString('email') ?? '';

        if (email.isNotEmpty) {
          context.read<ForgotPasswordCubit>().requestPasswordReset(email);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP has been resent!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No email found.')),
          );
        }
      },
    );
  }

  Widget _buildVerifyOTPButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_otpController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter the OTP')),
          );
        } else {
          context.read<VerifyOtpCubit>().verifyOtp(_otpController.text);
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
    return BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
      builder: (context, state) {
        return state is VerifyOtpLoading
            ? Container(
          color: Colors.black.withOpacity(0.5),
        )
            : const SizedBox.shrink();
      },
    );
  }
}

class _ResendOTPButton extends StatefulWidget {
  final VoidCallback onResend;

  const _ResendOTPButton({required this.onResend});

  @override
  State<_ResendOTPButton> createState() => _ResendOTPButtonState();
}

class _ResendOTPButtonState extends State<_ResendOTPButton>
    with AutomaticKeepAliveClientMixin {
  int _resendTimer = 60;
  bool _canResend = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _canResend = false;
      _resendTimer = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _canResend
            ? () {
          widget.onResend();
          _startResendTimer();
        }
            : null,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: _canResend
            ? const Text(
          'Resend OTP',
          style: TextStyle(fontSize: 14, color: Colors.white),
        )
            : Text(
          'Resend in $_resendTimer sec',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
