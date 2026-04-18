import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateSlotBloc, CreateSlotState>(
      builder: (context, state) {
        final dateText = state.selectedDate != null
            ? DateFormat('EEEE, MMMM d, y').format(state.selectedDate!)
            : 'SLOT DATE AND TIME';

        return ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: state.selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: Color(0xFFFFBF00),
                      onPrimary: Color(0xFF402D00),
                      surface: Color(0xFF1B1B1B),
                      onSurface: Color(0xFFE2E2E2),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (picked != null && context.mounted) {
              context.read<CreateSlotBloc>().add(CreateSlotEvent.dateChanged(picked));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFBF00),
            foregroundColor: const Color(0xFF402D00),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: const Color(0xFFFFBF00).withValues(alpha: 0.25),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 12),
              Text(
                dateText,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
