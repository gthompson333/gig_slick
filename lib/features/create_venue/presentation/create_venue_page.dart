import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../injection.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_venue_bloc.dart';

import '../../sign_in/bloc/auth_bloc.dart';
import '../../sign_in/bloc/auth_event.dart';
import '../../sign_in/bloc/auth_state.dart';

class CreateVenuePage extends StatelessWidget {
  const CreateVenuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateVenueBloc>(),
      child: const CreateVenueView(),
    );
  }
}

class CreateVenueView extends StatefulWidget {
  const CreateVenueView({super.key});

  @override
  State<CreateVenueView> createState() => _CreateVenueViewState();
}

class _CreateVenueViewState extends State<CreateVenueView> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _normalizePhoneNumber(String phone) {
    final numericOnly = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericOnly.length == 10) return '+1$numericOnly';
    if (phone.startsWith('+')) return phone;
    return '+$numericOnly';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceLow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CreateVenueBloc, CreateVenueState>(
            listener: (context, state) {
              if (state is CreateVenueSuccess) {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null && !user.isAnonymous) {
                  context.go('/dashboard');
                } else {
                  _showSecureVenueSheet(context, state.venueName);
                }
              } else if (state is CreateVenueFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLinkOtpSent) {
                _showOtpDialog(
                  context,
                  state.verificationId,
                  state.phoneNumber,
                );
              } else if (state is AuthAuthenticated) {
                context.go('/dashboard');
              } else if (state is AuthError) {
                _showErrorAlert(context, 'Security Error', state.message);
              }
            },
          ),
        ],
        child: BlocBuilder<CreateVenueBloc, CreateVenueState>(
          builder: (context, state) {
            final isLoading = state is CreateVenueLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Set Up Your Venue',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: AppColors.electricAmber,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nearly ready to get you going.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 56),
                  _buildTonalTextField(
                    controller: _nameController,
                    label: 'Venue Name',
                    hintText: 'e.g. The Blue Note',
                    icon: Icons.storefront_rounded,
                  ),
                  const SizedBox(height: 64),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _nameController,
                    builder: (context, value, child) {
                      final name = value.text.trim();
                      final isButtonEnabled = name.isNotEmpty && !isLoading;

                      return SizedBox(
                        height: 64,
                        child: ElevatedButton(
                          onPressed: isButtonEnabled
                              ? () {
                                  context.read<CreateVenueBloc>().add(
                                    CreateVenueSubmitted(
                                      name: name,
                                    ),
                                  );
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricAmber,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: AppColors.electricAmber
                                .withValues(alpha: 0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  'Create Venue',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isButtonEnabled
                                        ? Colors.black
                                        : Colors.black38,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSecureVenueSheet(BuildContext context, String venueName) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.all(32),
          decoration: const BoxDecoration(
            color: AppColors.surfaceMid,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.verified_user_rounded,
                color: AppColors.electricAmber,
                size: 48,
              ),
              const SizedBox(height: 24),
              Text(
                'Secure $venueName',
                textAlign: TextAlign.center,
                style: Theme.of(sheetContext).textTheme.headlineMedium
                    ?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Link your phone number to lock in your venue and manage gigs from anywhere.',
                textAlign: TextAlign.center,
                style: Theme.of(
                  sheetContext,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(sheetContext); // Close sheet
                  _showPhoneInputDialog(
                    context,
                  ); // Pass outer context which has the Bloc
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricAmber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Secure Now',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(sheetContext); // Close sheet
                  context.go('/dashboard');
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Skip for now',
                  style: TextStyle(
                    color: AppColors.textTertiary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  void _showPhoneInputDialog(BuildContext context) {
    final phoneController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceMid,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Secure Account',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.electricAmber,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your phone number to link your account.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              _buildTonalTextField(
                controller: phoneController,
                label: 'Phone Number',
                hintText: 'e.g. +1 555 000 0000',
                icon: Icons.phone_iphone_rounded,
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: phoneController,
              builder: (context, value, child) {
                final isButtonEnabled = value.text.trim().isNotEmpty;

                return ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          final phone = value.text.trim();
                          final normalized = _normalizePhoneNumber(phone);
                          context.read<AuthBloc>().add(
                            LinkPhoneRequested(normalized),
                          );
                          Navigator.pop(dialogContext);
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
                    'Send Code',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isButtonEnabled ? Colors.black : Colors.black38,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
    );
  }

  void _showOtpDialog(
    BuildContext context,
    String verificationId,
    String phoneNumber,
  ) {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceMid,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Verification Code',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.electricAmber,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the 6-digit code sent to $phoneNumber',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: AppColors.surfaceLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.textTertiary),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: otpController,
              builder: (context, value, child) {
                final isButtonEnabled = value.text.trim().length == 6;

                return ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          final code = value.text.trim();
                          context.read<AuthBloc>().add(
                            LinkOtpSubmitted(verificationId, code),
                          );
                          Navigator.pop(dialogContext);
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
                    'Verify',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isButtonEnabled ? Colors.black : Colors.black38,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
    );
  }

  void _showErrorAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceMid,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
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

  Widget _buildTonalTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceMid,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: theme.textTheme.bodyLarge,
            cursorColor: AppColors.electricAmber,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textTertiary,
              ),
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
        ),
      ],
    );
  }
}
