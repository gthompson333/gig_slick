import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_gig_bloc.dart';
import '../bloc/create_gig_event.dart';
import '../bloc/create_gig_state.dart';

class PayoutSection extends StatelessWidget {
  const PayoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateGigBloc, CreateGigState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceMid,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.02),
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Base Guarantee',
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '\$${state.baseGuarantee.toInt()}',
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.electricAmber,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: AppColors.electricAmber,
                  inactiveTrackColor: AppColors.surfaceHigh,
                  thumbColor: AppColors.electricAmber,
                  overlayColor: AppColors.electricAmber.withValues(alpha: 0.1),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 10,
                  ),
                ),
                child: Slider(
                  value: state.baseGuarantee,
                  min: 100,
                  max: 500,
                  divisions: 40,
                  onChanged: (value) {
                    context.read<CreateGigBloc>().add(
                      CreateGigEvent.guaranteeChanged(value),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$100 MIN',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  Text(
                    '\$500 MAX',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),

            ],
          ),
        );
      },
    );
  }
}
