import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';


class VenueNotes extends StatelessWidget {
  const VenueNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateSlotBloc, CreateSlotState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                'VENUE NOTES',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD4C5AB),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B1B),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextFormField(
                initialValue: state.venueNotes,
                onChanged: (value) {
                  context
                      .read<CreateSlotBloc>()
                      .add(CreateSlotEvent.venueNotesChanged(value));
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'e.g. Includes 2 Drink Vouchers & Sound Tech',
                  hintStyle: TextStyle(
                    color: const Color(0xFFE2E2E2).withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: const TextStyle(
                  color: Color(0xFFE2E2E2),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
