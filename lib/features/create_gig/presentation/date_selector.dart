import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_gig_bloc.dart';
import '../bloc/create_gig_event.dart';
import '../bloc/create_gig_state.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateGigBloc, CreateGigState>(
      builder: (context, state) {
        final dateText = DateFormat('EEEE, MMMM d, y').format(state.selectedDate);

        return ElevatedButton(
          onPressed: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: state.selectedDate,
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
              context.read<CreateGigBloc>().add(CreateGigEvent.dateChanged(picked));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.electricAmber,
            foregroundColor: Colors.black,
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
              const Icon(
                Icons.calendar_today,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                dateText.toUpperCase(),
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.black,
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
