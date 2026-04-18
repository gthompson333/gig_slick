import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateSlotBloc, CreateSlotState>(
      builder: (context, state) {
        final isSelected = state.selectedDate != null;
        final dateText = isSelected
            ? DateFormat('EEEE, MMMM d, y').format(state.selectedDate!)
            : 'SET SLOT DATE AND TIME';

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
                      primary: AppColors.electricAmber,
                      onPrimary: Colors.black,
                      surface: AppColors.surfaceMid,
                      onSurface: AppColors.textPrimary,
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
            backgroundColor: isSelected ? AppColors.electricAmber : AppColors.surfaceMid,
            foregroundColor: isSelected ? Colors.black : AppColors.textSecondary,
            padding: const EdgeInsets.symmetric(vertical: 20),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? Icons.calendar_today : Icons.calendar_today_outlined,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                dateText.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
