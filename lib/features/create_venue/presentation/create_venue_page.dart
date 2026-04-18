import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../injection.dart';
import '../bloc/create_venue_bloc.dart';

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
  final _genresController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _genresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313), // surface
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Color(0xFFE2E2E2), // on_surface
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFE2E2E2)),
      ),
      body: BlocConsumer<CreateVenueBloc, CreateVenueState>(
        listener: (context, state) {
          if (state is CreateVenueSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venue created successfully!'),
                backgroundColor: Color(0xFF00FFFF), // success cyan
              ),
            );
            // Redirect to dashboard
            if (context.mounted) {
              context.go('/dashboard');
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
        builder: (context, state) {
          final isLoading = state is CreateVenueLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Set Up Your Venue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.64,
                    color: Color(0xFFFFBF00), // Electric Amber
                  ),
                ),
                const SizedBox(height: 48),
                _buildTextField(
                  controller: _nameController,
                  label: 'Venue Name',
                  hintText: 'Venue Name',
                  icon: Icons.storefront,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<CreateVenueBloc>().add(
                                CreateVenueSubmitted(
                                  name: _nameController.text,
                                  genres: const [],
                                ),
                              );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFBF00), // Electric Amber
                    foregroundColor: const Color(0xFF6D5000), // on_primary_container
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF6D5000),
                          ),
                        )
                      : const Text(
                          'Create Venue',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFD4C5AB), // on_surface_variant
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: Color(0xFFE2E2E2),
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Inter',
              color: Color(0x4DE2E2E2),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFFD4C5AB)),
            filled: true,
            fillColor: const Color(0xFF2A2A2A), // surface-container-high
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFFFBF00), // Primary
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
