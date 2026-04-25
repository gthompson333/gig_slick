import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../injection.dart';
import '../../sign_in/bloc/auth_bloc.dart';
import '../../sign_in/bloc/auth_event.dart';
import '../../sign_in/bloc/auth_state.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const OnboardingView(),
    );
  }
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  String _getIdentifierType(String input) {
    if (input.contains('@')) return 'email';
    
    // Strip non-numeric for phone detection
    final numeric = input.replaceAll(RegExp(r'[^0-9+]'), '');
    if (numeric.startsWith('+') || numeric.length >= 10) return 'phone';
    
    return 'invalid';
  }

  String _normalizePhone(String input) {
    String phone = input.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (phone.length == 10 && !phone.startsWith('+')) {
      phone = '+1$phone';
    }
    return phone;
  }

  bool _isValidEmail(String input) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);
  }

  bool _isValidPhone(String input) {
    final normalized = _normalizePhone(input);
    return normalized.startsWith('+') && normalized.length >= 10;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          if (state.method == 'guest' || !state.hasVenue) {
            context.go('/create-venue');
          } else {
            context.go('/dashboard');
          }
        } else if (state is AuthOtpSent) {
          _showOtpDialog(context, state.verificationId, state.phoneNumber);
        } else if (state is AuthEmailLinkSent) {
          _showEmailSentDialog(context, state.email);
        } else if (state is AuthError) {
          // If a dialog is open (like the OTP dialog), this alert will show on top or after it.
          // However, the OTP dialog is already popped on 'VERIFY' tap.
          _showErrorAlert(context, state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.surfaceLow,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom -
                      80,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo Section
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 48),
                        Hero(
                          tag: 'app_logo',
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 120,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Gig Slick',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 48,
                            color: AppColors.electricAmber,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'A slicker way for venues to manage their gigs.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // Input & Buttons Section
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Smart Identifier Input
                        Text(
                          'Email or Phone Number',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMid,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.surfaceHigh,
                              width: 2,
                            ),
                          ),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _identifierController,
                            builder: (context, value, child) {
                              final type = _getIdentifierType(value.text);
                              IconData icon = Icons.login_rounded;
                              if (type == 'email') icon = Icons.email_rounded;
                              if (type == 'phone') icon = Icons.phone_rounded;

                              return TextField(
                                controller: _identifierController,
                                keyboardType: TextInputType.emailAddress,
                                style: theme.textTheme.bodyLarge,
                                cursorColor: AppColors.electricAmber,
                                decoration: InputDecoration(
                                  hintText: 'Email or Phone Number',
                                  hintStyle:
                                      theme.textTheme.bodyLarge?.copyWith(
                                        color: AppColors.textTertiary,
                                      ),
                                  prefixIcon: Icon(
                                    icon,
                                    color: AppColors.electricAmber,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),

                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _identifierController,
                          builder: (context, value, child) {
                            final input = value.text.trim();
                            final type = _getIdentifierType(input);
                            
                            bool isButtonEnabled = false;
                            String buttonText = 'Log in';

                            if (type == 'email') {
                              isButtonEnabled = _isValidEmail(input);
                              buttonText = 'Log in with Email';
                            } else if (type == 'phone') {
                              isButtonEnabled = _isValidPhone(input);
                              buttonText = 'Log in with Phone Number';
                            }

                            isButtonEnabled = isButtonEnabled && !isLoading;

                            return SizedBox(
                              height: 64,
                              child: ElevatedButton(
                                onPressed: isButtonEnabled
                                    ? () {
                                        if (type == 'email') {
                                          context.read<AuthBloc>().add(
                                            EmailLoginRequested(input),
                                          );
                                        } else {
                                          final phone = _normalizePhone(input);
                                          context.read<AuthBloc>().add(
                                            PhoneLoginRequested(phone),
                                          );
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.electricAmber,
                                  foregroundColor: Colors.black,
                                  disabledBackgroundColor: AppColors
                                      .electricAmber
                                      .withValues(alpha: 0.3),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : Text(
                                        buttonText,
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                              color: isButtonEnabled
                                                  ? Colors.black
                                                  : Colors.black38,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                      ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Guest Login Link
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  context.read<AuthBloc>().add(
                                    SignInAsGuestRequested(),
                                  );
                                },
                          child: Text(
                            'Sign in as Guest',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Takes 30 seconds to set up your venue.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOtpDialog(
    BuildContext context,
    String verificationId,
    String phone,
  ) {
    final otpController = TextEditingController();
    final authBloc = context.read<AuthBloc>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BlocProvider.value(
        value: authBloc,
        child: AlertDialog(
          backgroundColor: AppColors.surfaceMid,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Verification Code',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.electricAmber,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter the 6-digit code sent to\n$phone',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '000000',
                    hintStyle: TextStyle(color: AppColors.textTertiary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'CANCEL',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: otpController,
              builder: (builderContext, value, child) {
                final isButtonEnabled = value.text.trim().length == 6;

                return ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          final code = value.text.trim();
                          Navigator.pop(dialogContext);
                          builderContext.read<AuthBloc>().add(
                            OtpSubmitted(verificationId, code),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.electricAmber,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: AppColors.electricAmber.withValues(
                      alpha: 0.3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'VERIFY',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: isButtonEnabled ? Colors.black : Colors.black38,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceMid,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.redAccent),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Authentication Unsuccessful',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
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
  }

  void _showEmailSentDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceMid,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.electricAmber,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mark_email_read_rounded,
              size: 64,
              color: AppColors.electricAmber,
            ),
            const SizedBox(height: 24),
            Text(
              'A sign-in link has been sent to\n$email',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Click the link in your email to complete the login process.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'GOT IT',
              style: TextStyle(
                color: AppColors.electricAmber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
