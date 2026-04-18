import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../injection.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: const SignInView(),
    );
  }
}

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Kinetic Darkroom Base
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.inter()),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is AuthAuthenticated) {
            // Usually Route to Dashboard here
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully authenticated via: \${state.method}', style: GoogleFonts.inter(color: Colors.black)),
                backgroundColor: const Color(0xFFFFBF00),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gig Slick',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFBF00), // Electric Amber
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The Venue Manager’s Toolkit.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildTextField(
                    controller: _inputController,
                    hint: 'Phone Number',
                    icon: Icons.phone_outlined,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              context.read<AuthBloc>().add(
                                    SubmitEmailOrPhoneRequested(
                                      _inputController.text,
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBF00),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Get Started',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  /*
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or continue with',
                          style: GoogleFonts.inter(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                      const Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      _buildSocialButton(
                        onPressed: isLoading
                            ? null
                            : () => context.read<AuthBloc>().add(SignInWithPasskeyRequested()),
                        icon: Icons.fingerprint,
                        label: 'Sign in with FaceID / Passkey',
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        borderSide: const BorderSide(color: Colors.white24, width: 1.5),
                      ),
                      const SizedBox(height: 16),
                      _buildSocialButton(
                        onPressed: isLoading
                            ? null
                            : () => context.read<AuthBloc>().add(SignInWithAppleRequested()),
                        icon: Icons.apple,
                        label: 'Continue with Apple',
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        borderSide: const BorderSide(color: Colors.white12, width: 1.5),
                      ),
                      const SizedBox(height: 16),
                      _buildSocialButton(
                        onPressed: isLoading
                            ? null
                            : () => context.read<AuthBloc>().add(SignInWithGoogleRequested()),
                        icon: Icons.g_mobiledata, // Standard Google logo placeholder
                        label: 'Continue with Google',
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                    ],
                  ),
                  */
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<AuthBloc>().add(SignInAsGuestRequested());
                          },
                    child: Text(
                      'Continue as Guest',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white70,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'By continuing, you agree to the Gig Slick Terms of Service and Privacy Policy.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white38,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Tonal Layering
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: GoogleFonts.inter(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        ),
      ),
    );
  }

}
