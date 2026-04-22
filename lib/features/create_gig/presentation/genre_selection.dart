import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/create_gig_bloc.dart';
import '../bloc/create_gig_event.dart';
import '../bloc/create_gig_state.dart';

class GenreSelection extends StatelessWidget {
  const GenreSelection({super.key});

  final List<String> availableGenres = const [
    'Indie Rock',
    'Folk',
    'Blues',
    'Metal',
    'Electronic',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CreateGigBloc, CreateGigState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TARGET GENRES',
              style: textTheme.labelSmall?.copyWith(
                color: AppColors.textTertiary,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: availableGenres.map((genre) {
                final isSelected = state.selectedGenres.contains(genre);
                return GestureDetector(
                  onTap: () {
                    context.read<CreateGigBloc>().add(
                      CreateGigEvent.genreToggled(genre),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.electricAmber
                          : AppColors.surfaceMid,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.electricAmber.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      genre,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w900
                            : FontWeight.w600,
                        color: isSelected
                            ? Colors.black
                            : AppColors.textSecondary,
                        letterSpacing: isSelected ? 0.5 : 0,
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
