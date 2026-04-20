import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import 'performer_link_card.dart';
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
      body: BlocListener<DashboardBloc, DashboardState>(
        listener: (context, state) {
          state.maybeWhen(
            noVenue: () => context.go('/create-venue'),
            orElse: () {},
          );
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: CircularProgressIndicator(color: AppColors.electricAmber),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.electricAmber),
              ),
              noVenue: () => const Center(
                child: CircularProgressIndicator(color: AppColors.electricAmber),
              ),
              loaded: (slots, magicLink, venueName) => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Glassmorphic App Bar
                  SliverAppBar(
                    expandedHeight: 110,
                    collapsedHeight: 80,
                    pinned: true,
                    stretch: true,
                    backgroundColor: Colors.transparent,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () => _showLogoutDialog(context),
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                          tooltip: 'Log Out',
                        ),
                      ),
                    ],
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: const EdgeInsets.only(bottom: 12),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/logo.png',
                                height: 24,
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  venueName,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.titleLarge?.copyWith(
                                    color: AppColors.electricAmber,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
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
                        PerformerLinkCard(linkUrl: magicLink),
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

  void _showLogoutDialog(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAnonymous = user?.isAnonymous ?? true;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Log Out?',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
        ),
        content: Text(
          isAnonymous
              ? 'Are you sure you want to log out? Log in with your phone number before you leave to ensure you can get back to your venue.'
              : 'Are you sure you want to log out of GigSlick?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go('/onboarding');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricAmber,
              foregroundColor: Colors.black,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            child: const Text(
              'LOG OUT',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
