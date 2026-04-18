import 'package:flutter/material.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Scheduled Slots',
                style: TextStyle(
                  color: Color(0xFFFFBF00),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Plus Jakarta Sans',
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                'Viewing next 14 days',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (slots.isEmpty)
          _buildEmptyState()
        else
          ...slots.map((slot) => SlotCard(slot: slot)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            color: Colors.white.withValues(alpha: 0.2),
            size: 48,
          ),
          const SizedBox(height: 20),
          const Text(
            'No slots scheduled',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Create Slot" to start filling\nyour calendar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
