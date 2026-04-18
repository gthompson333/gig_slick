import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../data/entities/slot.dart';

class SlotCard extends StatelessWidget {
  final Slot slot;

  const SlotCard({
    super.key,
    required this.slot,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = slot.status == SlotStatus.pending;
    final accentColor = isPending ? AppColors.electricAmber : AppColors.kineticCyan;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.03),
            offset: const Offset(0, -1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, MMM d').format(slot.date),
                  style: textTheme.titleLarge?.copyWith(
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${DateFormat('h:mm a').format(slot.startTime)} - ${DateFormat('h:mm a').format(slot.endTime)}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isPending
                      ? '${slot.pendingCount} PENDING'
                      : 'CONFIRMED',
                  style: textTheme.labelSmall?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (!isPending && slot.confirmedPerformerName != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (slot.confirmedPerformerAvatarUrl != null)
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            slot.confirmedPerformerAvatarUrl!,
                            width: 24,
                            height: 24,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      const Icon(Icons.person, size: 24, color: AppColors.textTertiary),
                    const SizedBox(width: 10),
                    Text(
                      slot.confirmedPerformerName!,
                      style: textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
