import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../injection.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/performer_bloc.dart';
import '../bloc/performer_event.dart';
import '../bloc/performer_state.dart';

class PerformerGigsListPage extends StatelessWidget {
  final String venueId;

  const PerformerGigsListPage({
    super.key,
    required this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PerformerBloc>()..add(LoadLiveGigsRequested(venueId)),
      child: PerformerGigsListView(venueId: venueId),
    );
  }
}

class PerformerGigsListView extends StatelessWidget {
  final String venueId;

  const PerformerGigsListView({
    super.key,
    required this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: BlocBuilder<PerformerBloc, PerformerState>(
            builder: (context, state) {
              if (state is PerformerInitial || state is PerformerLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.electricAmber),
                );
              }

              if (state is PerformerLiveGigsLoaded) {
                final venueName = state.venueName;
                final gigs = state.gigs;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      backgroundColor: const Color(0xFF121212).withValues(alpha: 0.9),
                      centerTitle: true,
                      title: Text(
                        venueName,
                        style: textTheme.headlineSmall?.copyWith(
                          color: AppColors.electricAmber,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Text(
                          'Available Gigs',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    if (gigs.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'No available gigs at the moment.',
                            style: textTheme.bodyLarge?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final gig = gigs[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    context.go('/v/$venueId/g/${gig.id}');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceMid,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: AppColors.electricAmber.withValues(alpha: 0.1),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat('EEEE, MMMM d, yyyy').format(gig.date),
                                              style: textTheme.titleLarge?.copyWith(
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(Icons.schedule, color: AppColors.textTertiary, size: 16),
                                                const SizedBox(width: 8),
                                                Text(
                                                  gig.setTime,
                                                  style: textTheme.bodyMedium?.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: AppColors.electricAmber,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: gigs.length,
                          ),
                        ),
                      ),
                    const SliverPadding(padding: EdgeInsets.only(bottom: 48)),
                  ],
                );
              }

              if (state is PerformerError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.redAccent,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Error Loading Gigs',
                          style: textTheme.headlineMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PerformerBloc>().add(LoadLiveGigsRequested(venueId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.surfaceHigh,
                            foregroundColor: AppColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                          ),
                          child: const Text('RETRY'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Center(
                child: Text('Something went wrong.', style: textTheme.bodyLarge),
              );
            },
          ),
        ),
      ),
    );
  }
}
