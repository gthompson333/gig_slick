import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';

class PayoutSection extends StatelessWidget {
  const PayoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateSlotBloc, CreateSlotState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1B1B),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Base Guarantee',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFE2E2E2),
                    ),
                  ),
                  Text(
                    '\$${state.baseGuarantee.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Color(0xFFFFBF00),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFFFFBF00),
                  inactiveTrackColor: const Color(0xFF353535),
                  thumbColor: const Color(0xFFFFBF00),
                  overlayColor: const Color(0xFFFFBF00).withValues(alpha: 0.2),
                  trackHeight: 8,
                ),
                child: Slider(
                  value: state.baseGuarantee,
                  min: 100,
                  max: 500,
                  divisions: 40,
                  onChanged: (value) {
                    context
                        .read<CreateSlotBloc>()
                        .add(CreateSlotEvent.guaranteeChanged(value));
                  },
                ),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$100 MIN',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Color(0xFFD4C5AB),
                    ),
                  ),
                  Text(
                    '\$500 MAX',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: Color(0xFFD4C5AB),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '70/30 Door Split',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFFE2E2E2),
                          ),
                        ),
                        Text(
                          'Standard Performer Bonus',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD4C5AB),
                          ),
                        ),
                      ],
                    ),
                    Switch(
                      value: state.is7030Split,
                      onChanged: (value) {
                        context
                            .read<CreateSlotBloc>()
                            .add(CreateSlotEvent.splitToggled(value));
                      },
                      activeThumbColor: const Color(0xFF6D5000),
                      activeTrackColor: const Color(0xFFFFBF00),
                      inactiveThumbColor: const Color(0xFFD4C5AB),
                      inactiveTrackColor: const Color(0xFF353535),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
