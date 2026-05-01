import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/data/entities/gig.dart';
import '../bloc/gig_applications_bloc.dart';
import '../bloc/gig_applications_event.dart';
import '../bloc/gig_applications_state.dart';
import '../data/entities/gig_application.dart';


class ApplicationDetailsPage extends StatelessWidget {
  final GigApplication application;
  final Gig gig;

  const ApplicationDetailsPage({
    super.key,
    required this.application,
    required this.gig,
  });

  Future<void> _launchUrl(BuildContext context, String url) async {
    String finalUrl = url.trim();
    if (finalUrl.isEmpty) {
      _showErrorDialog(context);
      return;
    }

    // Auto-prepend https if missing
    if (!finalUrl.startsWith('http://') && !finalUrl.startsWith('https://')) {
      finalUrl = 'https://$finalUrl';
    }

    final uri = Uri.tryParse(finalUrl);
    if (uri == null) {
      _showErrorDialog(context);
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        // Fallback: try to launch anyway if canLaunchUrl is overly pessimistic
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } catch (e) {
          if (context.mounted) _showErrorDialog(context);
        }
      }
    } catch (e) {
      if (context.mounted) _showErrorDialog(context);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Invalid Link',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'The performer provided a URL that cannot be opened. You may want to contact them at their email address.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: AppColors.electricAmber,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Confirm Booking?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: Text(
          'Are you sure you want to book ${application.performerName} for this gig? This will notify the performer and close other applications.',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<GigApplicationsBloc>().add(
                GigApplicationsEvent.confirmApplicationRequested(
                  gigId: gig.id,
                  applicationId: application.id,
                  performerName: application.performerName,
                ),
              );
            },
            child: const Text(
              'Confirm & Book',
              style: TextStyle(
                color: AppColors.electricAmber,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocConsumer<GigApplicationsBloc, GigApplicationsState>(
      listener: (context, state) {
        state.when(
          initial: () {},
          confirming: () {},
          confirmed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.electricAmber,
                  size: 48,
                ),
                title: const Text('Booking Confirmed'),
                content: Text(
                  '${application.performerName} has been booked for this gig.',
                ),
                actions: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.go('/dashboard');
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.electricAmber,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text('Error booking performer: $message'),
              ),
            );
          },
        );
      },
      builder: (context, state) {
        final isSubmitting = state.maybeWhen(
          confirming: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: AppColors.surfaceLow,
          appBar: AppBar(
            backgroundColor: AppColors.surfaceLow.withValues(alpha: 0.8),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary,
              ),
              onPressed: () => context.pop(),
            ),
            centerTitle: true,
            title: Text(
              'Application Details',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Text(
                  application.performerName,
                  style: textTheme.displayLarge?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  application.performerEmail,
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // View Social Media Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl(context, application.performerLink),
                    icon: const Icon(Icons.open_in_new_rounded, size: 20),
                    label: const Text('View Social Media'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceHigh,
                      foregroundColor: AppColors.kineticCyan,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Gig Summary Card
                Text(
                  'GIG SUMMARY',
                  style: textTheme.labelSmall?.copyWith(
                    letterSpacing: 2,
                    color: AppColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceMid,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        Icons.calendar_today_rounded,
                        DateFormat.yMMMMEEEEd().format(gig.date),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Colors.white10, height: 1),
                      ),
                      _buildSummaryRow(
                        Icons.access_time_rounded,
                        'Set: ${gig.setTime} (Load-in: ${gig.loadInTime})',
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Colors.white10, height: 1),
                      ),
                      _buildSummaryRow(
                        Icons.payments_rounded,
                        '\$${gig.baseGuarantee.toStringAsFixed(0)} Base Guarantee',
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: ElevatedButton(
                onPressed: isSubmitting ? null : () => _showConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electricAmber,
                  foregroundColor: Colors.black,
                  disabledBackgroundColor: AppColors.electricAmber.withValues(alpha: 0.3),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: AppColors.electricAmber.withValues(alpha: 0.4),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 3,
                        ),
                      )
                    : Text(
                        'Confirm & Book Performer',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(IconData icon, String text, {bool isHighlight = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isHighlight ? AppColors.electricAmber : AppColors.textTertiary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isHighlight ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
