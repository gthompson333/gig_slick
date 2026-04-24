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
import 'scheduled_gigs_feed.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<DashboardBloc>()..add(const DashboardEvent.loadRequested()),
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
            accountDeleted: () => context.go('/onboarding'),
            orElse: () {},
          );
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.electricAmber,
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.electricAmber,
                ),
              ),
              noVenue: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.electricAmber,
                ),
              ),
              accountDeleted: () => const Center(
                child: CircularProgressIndicator(
                  color: AppColors.electricAmber,
                ),
              ),
              loaded: (venueId, gigs, gigLink, venueName) => CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Glassmorphic App Bar
                  SliverAppBar(
                    pinned: true,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/logo.png', height: 24),
                        const SizedBox(width: 12),
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
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () => _showAccountMenuDialog(context),
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.textSecondary,
                            size: 24,
                          ),
                          tooltip: 'Account Settings',
                        ),
                      ),
                    ],
                    flexibleSpace: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          color: AppColors.background.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),

                  // Main Content
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 16),
                        PerformerLinkCard(linkUrl: gigLink),
                        const SizedBox(height: 16),
                        ScheduledGigsFeed(
                          gigs: gigs,
                          gigLink: gigLink,
                          venueName: venueName,
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              error: (message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
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
                        'Unable to load gigs',
                        style: textTheme.headlineSmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message.contains('failed-precondition')
                            ? 'The database is preparing a new index for your gigs. This usually takes a few minutes.'
                            : message,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.read<DashboardBloc>().add(
                          const DashboardEvent.loadRequested(),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceHigh,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                        child: const Text('RETRY'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return state.maybeWhen(
            loaded: (venueId, gigs, magicLink, venueName) =>
                FloatingActionButton.extended(
                  onPressed: () => context.push('/create-gig', extra: {'venueId': venueId, 'venueName': venueName}),
                  backgroundColor: AppColors.electricAmber,
                  foregroundColor: Colors.black,
                  elevation: 8,
                  label: const Text(
                    'New Gig',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _showAccountMenuDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Account Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: AppColors.textSecondary,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(color: AppColors.textPrimary),
              ),
              onTap: () {
                Navigator.pop(innerContext);
                _showLogoutDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever_rounded,
                color: Colors.redAccent,
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(color: Colors.redAccent),
              ),
              onTap: () {
                Navigator.pop(innerContext);
                _showDeleteAccountDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Log Out?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(innerContext),
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
              Navigator.pop(innerContext);
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
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Delete Account?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.redAccent,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: Text(
          'This action is permanent. All your data, including your venue and all scheduled gigs, will be permanently deleted.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(innerContext),
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
            onPressed: () {
              Navigator.pop(innerContext);
              context.read<DashboardBloc>().add(
                const DashboardEvent.accountDeletionRequested(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            child: const Text(
              'DELETE',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
          ),
        ],
      ),
    );
  }
}
