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
        ...slots.map((slot) => SlotCard(slot: slot)),
      ],
    );
  }
}
