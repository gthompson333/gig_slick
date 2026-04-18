import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';

class ScheduleDetails extends StatelessWidget {
  const ScheduleDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateSlotBloc, CreateSlotState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'LOAD-IN',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Container(
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
                    child: TextFormField(
                      initialValue: state.loadInTime,
                      onChanged: (value) {
                        context
                            .read<CreateSlotBloc>()
                            .add(CreateSlotEvent.loadInTimeChanged(value));
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Text(
                      'SET TIMES',
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.textTertiary,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  Container(
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
                    child: TextFormField(
                      initialValue: state.setTimes,
                      onChanged: (value) {
                        context
                            .read<CreateSlotBloc>()
                            .add(CreateSlotEvent.setTimesChanged(value));
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
