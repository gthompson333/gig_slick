import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../data/entities/gig.dart';

class GigCard extends StatelessWidget {
  final Gig gig;
  final String gigLink;

  const GigCard({
    super.key,
    required this.gig,
    required this.gigLink,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = gig.status == GigStatus.pending;
    final accentColor = isPending ? AppColors.electricAmber : AppColors.kineticCyan;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => context.push('/gig-details', extra: {
        'gig': gig,
        'gigLink': gigLink,
      }),
      borderRadius: BorderRadius.circular(24),
      child: Container(
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
                    DateFormat('EEEE, MMM d').format(gig.date),
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
                        gig.setTimes,
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
                        ? '${gig.pendingCount} PENDING'
                        : 'CONFIRMED',
                    style: textTheme.labelSmall?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                if (!isPending && gig.confirmedPerformerName != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (gig.confirmedPerformerAvatarUrl != null)
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
                              gig.confirmedPerformerAvatarUrl!,
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
                        gig.confirmedPerformerName!,
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
      ),
    );
  }
}
