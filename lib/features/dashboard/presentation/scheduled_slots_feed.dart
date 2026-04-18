import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/entities/slot.dart';
import 'slot_card.dart';

class ScheduledSlotsFeed extends StatelessWidget {
  final List<Slot> slots;

  const ScheduledSlotsFeed({
    super.key,
    required this.slots,
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
                'Scheduled Slots',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.electricAmber,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Next 14 Days',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        if (slots.isEmpty)
          _buildEmptyState(context)
        else
          ...slots.map((slot) => SlotCard(slot: slot)),
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
            'No slots scheduled',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Tap "Create Slot" to start filling\nyour calendar.',
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
