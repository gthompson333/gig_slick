import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final color = isPending ? const Color(0xFFFFBF00) : const Color(0xFF00FFFF);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1B1B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('EEEE, MMMM d').format(slot.date),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 14,
                    color: Colors.white.withOpacity(0.4),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${DateFormat('h:mm a').format(slot.startTime)} - ${DateFormat('h:mm a').format(slot.endTime)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: color.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  isPending
                      ? '${slot.pendingCount} Pending'
                      : 'Confirmed',
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (!isPending && slot.confirmedPerformerName != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (slot.confirmedPerformerAvatarUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          slot.confirmedPerformerAvatarUrl!,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person, size: 24),
                        ),
                      )
                    else
                      const Icon(Icons.person, size: 24, color: Colors.white24),
                    const SizedBox(width: 8),
                    Text(
                      slot.confirmedPerformerName!,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              else
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.35),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
