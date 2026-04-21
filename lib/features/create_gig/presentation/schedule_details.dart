import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_gig_bloc.dart';
import '../bloc/create_gig_event.dart';
import '../bloc/create_gig_state.dart';

class ScheduleDetails extends StatelessWidget {
  const ScheduleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateGigBloc, CreateGigState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _TimeField(
                label: 'LOAD-IN',
                value: state.loadInTime,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 19, minute: 0),
                    builder: (context, child) => _TimePickerTheme(child: child!),
                  );
                  if (time != null && context.mounted) {
                    context
                        .read<CreateGigBloc>()
                        .add(CreateGigEvent.loadInTimeChanged(time.format(context)));
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _TimeField(
                label: 'SET TIMES',
                value: state.setTimes,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 21, minute: 0),
                    builder: (context, child) => _TimePickerTheme(child: child!),
                  );
                  if (time != null && context.mounted) {
                    context
                        .read<CreateGigBloc>()
                        .add(CreateGigEvent.setTimesChanged(time.format(context)));
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TimeField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _TimeField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 2,
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surfaceMid,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.02),
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Icon(
                  Icons.access_time_rounded,
                  color: AppColors.textTertiary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimePickerTheme extends StatelessWidget {
  final Widget child;

  const _TimePickerTheme({required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.electricAmber,
          onPrimary: Colors.black,
          surface: AppColors.surfaceMid,
          onSurface: AppColors.textPrimary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.electricAmber,
          ),
        ),
      ),
      child: child,
    );
  }
}
