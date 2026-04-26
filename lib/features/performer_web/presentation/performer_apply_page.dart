import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../injection.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/performer_bloc.dart';
import '../bloc/performer_event.dart';
import '../bloc/performer_state.dart';

class PerformerApplyPage extends StatelessWidget {
  final String venueId;
  final String gigId;

  const PerformerApplyPage({
    super.key,
    required this.venueId,
    required this.gigId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PerformerBloc>()..add(LoadGigRequested(venueId, gigId)),
      child: PerformerApplyView(venueId: venueId, gigId: gigId),
    );
  }
}

class PerformerApplyView extends StatefulWidget {
  final String venueId;
  final String gigId;

  const PerformerApplyView({
    super.key,
    required this.venueId,
    required this.gigId,
  });

  @override
  State<PerformerApplyView> createState() => _PerformerApplyViewState();
}

class _PerformerApplyViewState extends State<PerformerApplyView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _socialController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: BlocConsumer<PerformerBloc, PerformerState>(
            listener: (context, state) {
              if (state is PerformerError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is PerformerSubmissionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is PerformerInitial || state is PerformerLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.electricAmber),
                );
              }

              if (state is PerformerSubmittedSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildSuccessMessage(textTheme),
                );
              }

              if (state is PerformerLoaded || state is PerformerSubmitting || state is PerformerSubmissionError) {
                final gig = state is PerformerLoaded
                    ? state.gig
                    : (state is PerformerSubmitting
                        ? state.gig
                        : (state as PerformerSubmissionError).gig);
                final venueName = state is PerformerLoaded
                    ? state.venueName
                    : (state is PerformerSubmitting
                        ? state.venueName
                        : (state as PerformerSubmissionError).venueName);
                final isSubmitting = state is PerformerSubmitting;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24.0),
                        child: _buildFormContent(context, textTheme, venueName, gig, isSubmitting),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: _buildSubmitButton(context, textTheme, venueName, isSubmitting),
                    ),
                  ],
                );
              }

              if (state is PerformerError) {
                final bool isNotFound = state.message == 'Gig not found.';
                final title = widget.gigId.isEmpty
                    ? 'Invalid Link'
                    : (isNotFound ? 'Gig Not Found' : 'Error Loading Gig');
                final desc = widget.gigId.isEmpty
                    ? 'Please make sure you have the full link provided by the venue.'
                    : (isNotFound ? 'This gig may have been deleted or the link is incorrect.' : state.message);

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          title,
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          desc,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Text('Something went wrong.', style: textTheme.bodyLarge),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    TextTheme textTheme,
    String displayVenueName,
    gig,
    bool isSubmitting,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            displayVenueName,
            style: textTheme.displayLarge?.copyWith(
              color: AppColors.electricAmber,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '$displayVenueName is looking for a performer for this slot.',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceMid,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Gig Details',
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(gig.date),
                  style: textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.schedule, color: AppColors.textTertiary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      gig.setTime,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          TextFormField(
            controller: _nameController,
            enabled: !isSubmitting,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Performer Name',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(color: Colors.redAccent),
            ),
            validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            enabled: !isSubmitting,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Email Address',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(color: Colors.redAccent),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email address';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value.trim())) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _socialController,
            enabled: !isSubmitting,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Social Media Handle',
              hintStyle: const TextStyle(color: AppColors.textTertiary),
              filled: true,
              fillColor: const Color(0xFF2A2A2A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorStyle: const TextStyle(color: Colors.redAccent),
            ),
            validator: (value) =>
                value == null || value.trim().isEmpty ? 'Please enter your social media handle' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(
    BuildContext context,
    TextTheme textTheme,
    String displayVenueName,
    bool isSubmitting,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(99),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFB800), // Yellow
            Color(0xFFF57C00), // Orange
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: isSubmitting
            ? null
            : () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<PerformerBloc>().add(
                        SubmitApplicationRequested(
                          gigId: widget.gigId,
                          venueName: displayVenueName,
                          performerName: _nameController.text.trim(),
                          performerEmail: _emailController.text.trim(),
                          performerLink: _socialController.text.trim(),
                        ),
                      );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                'Submit Application',
                style: textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
      ),
    );
  }

  Widget _buildSuccessMessage(TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.electricAmber.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: AppColors.electricAmber,
            size: 64,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Application Submitted!',
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'The venue has received your application. They will reach out to you if it\'s a match.',
          style: textTheme.titleMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
