import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../injection.dart';
import '../../../core/theme/app_colors.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surfaceLow,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<CreateVenueBloc, CreateVenueState>(
        listener: (context, state) {
          if (state is CreateVenueSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venue created successfully!'),
                backgroundColor: AppColors.kineticCyan,
              ),
            );
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
                SizedBox(
                  height: 64,
                  child: ElevatedButton(
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
                      backgroundColor: AppColors.electricAmber,
                      foregroundColor: Colors.black,
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
                              color: Colors.black,
                            ),
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

  Widget _buildTonalTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
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
            style: theme.textTheme.bodyLarge,
            cursorColor: AppColors.electricAmber,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.textTertiary,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 16, right: 12),
                child: Icon(icon, color: AppColors.electricAmber.withValues(alpha: 0.7)),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
            ),
          ),
        ),
      ],
    );
  }
}
