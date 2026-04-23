import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/entities/gig.dart';
import 'gig_card.dart';

class ScheduledGigsFeed extends StatelessWidget {
  final List<Gig> gigs;
  final String gigLink;
  final String venueName;

  const ScheduledGigsFeed({
    super.key,
    required this.gigs,
    required this.gigLink,
    required this.venueName,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Scheduled Gigs',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.electricAmber,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        if (gigs.isEmpty)
          _buildEmptyState(context)
        else
          ...gigs.map((gig) => GigCard(
                gig: gig,
                gigLink: gigLink,
                venueName: venueName,
              )),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.02),
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.surfaceHigh,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.textTertiary,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No gigs scheduled',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap "Create Gig" to start filling your calendar.',
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textTertiary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
