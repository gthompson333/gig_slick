import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';

class GenreSelection extends StatelessWidget {
  const GenreSelection({super.key});

  final List<String> availableGenres = const [
    'Indie Rock',
    'Folk',
    'Blues',
    'Metal',
    'Electronic'
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateSlotBloc, CreateSlotState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TARGET GENRES',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: Color(0xFFD4C5AB),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableGenres.map((genre) {
                final isSelected = state.selectedGenres.contains(genre);
                return GestureDetector(
                  onTap: () {
                    context
                        .read<CreateSlotBloc>()
                        .add(CreateSlotEvent.genreToggled(genre));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFFBF00)
                          : const Color(0xFF353535),
                      borderRadius: BorderRadius.circular(99),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFFFBF00)
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      genre,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected
                            ? const Color(0xFF6D5000)
                            : const Color(0xFFE2E2E2),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
