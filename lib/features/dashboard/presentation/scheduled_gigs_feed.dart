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

  // Priority order: pending first, then live, confirmed, draft last.
  static const _statusPriority = {
    GigStatus.pending: 0,
    GigStatus.live: 1,
    GigStatus.confirmed: 2,
    GigStatus.draft: 3,
  };

  List<Gig> _sortedGigs() {
    final sorted = [...gigs];
    sorted.sort((a, b) {
      final priorityCompare =
          (_statusPriority[a.status] ?? 99).compareTo(_statusPriority[b.status] ?? 99);
      if (priorityCompare != 0) return priorityCompare;
      // Secondary: ascending date (soonest first within same status group)
      return a.date.compareTo(b.date);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sorted = _sortedGigs();

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
                style: textTheme.titleLarge?.copyWith(
                  color: AppColors.electricAmber,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        if (sorted.isEmpty)
          _buildEmptyState(context)
        else
          ...sorted.map((gig) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: GigCard(
                  gig: gig,
                  gigLink: gigLink,
                  venueName: venueName,
                ),
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
            'Tap "New Gig" to start filling your calendar.',
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
