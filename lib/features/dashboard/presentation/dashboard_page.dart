import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'magic_link_card.dart';
import 'scheduled_slots_feed.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DashboardBloc>()..add(const DashboardEvent.loadRequested()),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.surfaceLow,
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(
              child: CircularProgressIndicator(color: AppColors.electricAmber),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.electricAmber),
            ),
            loaded: (slots, magicLink) => CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Glassmorphic App Bar
                SliverAppBar(
                  expandedHeight: 140,
                  collapsedHeight: 80,
                  pinned: true,
                  stretch: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 24,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'The Commonwealth',
                              style: textTheme.titleLarge?.copyWith(
                                color: AppColors.electricAmber,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        background: Container(
                          color: AppColors.background.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      MagicLinkCard(linkUrl: magicLink),
                      const SizedBox(height: 16),
                      ScheduledSlotsFeed(slots: slots),
                    ]),
                  ),
                ),
              ],
            ),
            error: (message) => Center(
              child: Text(
                'Error: $message',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-slot'),
        backgroundColor: AppColors.electricAmber,
        foregroundColor: Colors.black,
        elevation: 8,
        label: const Text(
          'CREATE SLOT',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        icon: const Icon(Icons.add, size: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(99),
        ),
      ),
    );
  }
}
