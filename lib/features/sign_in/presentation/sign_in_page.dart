import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignInView();
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceLow,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.surfaceMid,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                title: const Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.redAccent),
                    SizedBox(width: 12),
                    Text(
                      'Authentication Error',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                content: Text(
                  state.message,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        color: AppColors.electricAmber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is AuthAuthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully authenticated'),
                backgroundColor: AppColors.electricAmber,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final isOtpSent = state is AuthOtpSent;
          final verificationId = state is AuthOtpSent ? state.verificationId : '';
          final phoneNumber = state is AuthOtpSent ? state.phoneNumber : '';

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Center(
                    child: Hero(
                      tag: 'app_logo',
                      child: Image.asset('assets/images/logo.png', height: 120),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Gig Slick',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      color: AppColors.electricAmber,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Venue Manager’s Toolkit.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 64),
                  if (!isOtpSent)
                    _buildPhoneInputView(theme, isLoading)
                  else
                    _buildOtpInputView(
                      theme,
                      isLoading,
                      verificationId,
                      phoneNumber,
                    ),
                  const SizedBox(height: 40),
                  if (!isOtpSent)
                    GestureDetector(
                      onTap: isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                SignInAsGuestRequested(),
                              );
                            },
                      child: Text(
                        'Continue as Guest',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 64),
                  Text(
                    'By continuing, you agree to the Gig Slick\nTerms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhoneInputView(ThemeData theme, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTonalTextField(
          controller: _phoneController,
          hint: 'Phone Number',
          icon: Icons.phone_android_rounded,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<AuthBloc>().add(
                          PhoneLoginRequested(_phoneController.text),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricAmber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    'Get Started',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputView(
    ThemeData theme,
    bool isLoading,
    String verificationId,
    String phoneNumber,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Verification Code',
          style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Sent to $phoneNumber',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildTonalTextField(
          controller: _otpController,
          hint: '6-digit code',
          icon: Icons.lock_outline_rounded,
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 64,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<AuthBloc>().add(
                          OtpSubmitted(verificationId, _otpController.text),
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricAmber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 3,
                    ),
                  )
                : Text(
                    'Verify Code',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: isLoading
              ? null
              : () {
                  // Simply clear the state to go back to phone input
                  // In a real app, you might want a specific event to reset auth state
                  context.read<AuthBloc>().add(AuthErrorOccurred('')); 
                },
          child: const Text(
            'Change Phone Number',
            style: TextStyle(color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }

  Widget _buildTonalTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        style: theme.textTheme.bodyLarge,
        cursorColor: AppColors.electricAmber,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textTertiary,
          ),
          counterText: "",
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 12),
            child: Icon(
              icon,
              color: AppColors.electricAmber.withValues(alpha: 0.7),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 22,
          ),
        ),
      ),
    );
  }
}
