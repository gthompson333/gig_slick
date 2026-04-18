import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';

class VenueNotes extends StatelessWidget {
  const VenueNotes({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateSlotBloc, CreateSlotState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text(
                'VENUE NOTES',
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
                initialValue: state.venueNotes,
                onChanged: (value) {
                  context
                      .read<CreateSlotBloc>()
                      .add(CreateSlotEvent.venueNotesChanged(value));
                },
                maxLines: 2,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'e.g. Includes 2 Drink Vouchers & Sound Tech',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
