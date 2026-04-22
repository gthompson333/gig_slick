import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../dashboard/data/entities/gig.dart';
import '../../dashboard/presentation/performer_link_card.dart';
import '../bloc/gig_details_bloc.dart';
import '../bloc/gig_details_event.dart';
import '../bloc/gig_details_state.dart';

class GigDetailsPage extends StatelessWidget {
  final Gig gig;
  final String gigLink;

  const GigDetailsPage({super.key, required this.gig, required this.gigLink});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GigDetailsBloc>(),
      child: GigDetailsView(gig: gig, gigLink: gigLink),
    );
  }
}

class GigDetailsView extends StatelessWidget {
  final Gig gig;
  final String gigLink;

  const GigDetailsView({super.key, required this.gig, required this.gigLink});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isPending = gig.status == GigStatus.pending;
    final accentColor = isPending
        ? AppColors.electricAmber
        : AppColors.kineticCyan;

    return BlocListener<GigDetailsBloc, GigDetailsState>(
      listener: (context, state) {
        state.maybeWhen(
          deleted: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gig successfully deleted'),
                backgroundColor: AppColors.surfaceHigh,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop();
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $message'),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceLow,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Standard Pinned App Bar for Navigation
            SliverAppBar(
              pinned: true,
              backgroundColor: AppColors.surfaceLow.withValues(alpha: 0.8),
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => context.pop(),
              ),
              centerTitle: true,
              title: Text(
                'Gig Details',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => _showActionsBottomSheet(context),
                  tooltip: 'Actions',
                ),
                const SizedBox(width: 8),
              ],
            ),

            // Main content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status Badge
                    _buildStatusBadge(accentColor, isPending, textTheme),
                    const SizedBox(height: 16),

                    // Date header
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(gig.date),
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Detail Grid
                    Row(
                      children: [
                        _buildDetailItem(
                          context,
                          Icons.schedule_rounded,
                          'LOAD-IN',
                          gig.loadInTime,
                        ),
                        const SizedBox(width: 24),
                        _buildDetailItem(
                          context,
                          Icons.timer_rounded,
                          'SET TIMES',
                          gig.setTimes,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Financial Section
                    _buildSectionHeader(textTheme, 'FINANCIALS'),
                    const SizedBox(height: 16),
                    _buildCard(
                      child: Column(
                        children: [
                          _buildInfoRow(
                            'Base Guarantee',
                            '\$${gig.baseGuarantee.toStringAsFixed(0)}',
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Divider(color: Colors.white10),
                          ),
                          _buildInfoRow(
                            'Split Terms',
                            gig.is7030Split
                                ? '70/30 Profit Share'
                                : 'Guarantee Only',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Venue Notes Section
                    if (gig.venueNotes.isNotEmpty) ...[
                      _buildSectionHeader(textTheme, 'VENUE NOTES'),
                      const SizedBox(height: 16),
                      _buildCard(
                        child: Text(
                          gig.venueNotes,
                          style: textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],

                    // Target Genres Section
                    if (gig.targetGenres.isNotEmpty) ...[
                      _buildSectionHeader(textTheme, 'TARGET GENRES'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: gig.targetGenres.map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceHigh,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Text(
                              genre,
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 40),
                    ],

                    // Invitation Section
                    _buildSectionHeader(textTheme, 'INVITATION'),
                    const SizedBox(height: 16),
                    PerformerLinkCard(linkUrl: gigLink),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showActionsBottomSheet(BuildContext parentContext) {
    final gigDetailsBloc = parentContext.read<GigDetailsBloc>();

    showModalBottomSheet(
      context: parentContext,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceMid,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _buildActionItem(
                  context,
                  icon: Icons.edit_rounded,
                  label: 'EDIT GIG',
                  onTap: () async {
                    Navigator.pop(context); // Dismiss bottom sheet
                    final result = await parentContext.pushNamed<bool>(
                      '/edit-gig',
                      extra: {'venueId': gig.venueId, 'gig': gig},
                    );
                    if (result == true && parentContext.mounted) {
                      parentContext
                          .pop(); // Return to dashboard to see updated data
                    }
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Divider(color: Colors.white10),
                ),
                _buildActionItem(
                  context,
                  icon: Icons.delete_rounded,
                  label: 'DELETE GIG',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteConfirmation(parentContext, gigDetailsBloc);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isDestructive ? Colors.redAccent : AppColors.textPrimary,
        size: 24,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isDestructive ? Colors.redAccent : AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          fontSize: 14,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
    );
  }

  void _showDeleteConfirmation(BuildContext context, GigDetailsBloc bloc) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text(
          'Delete Gig?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: const Text(
          'This will permanently remove this gig and all associated performer applications. This action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
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
              Navigator.pop(dialogContext);
              bloc.add(GigDetailsEvent.deleteRequested(gig.id));
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

  Widget _buildStatusBadge(Color color, bool isPending, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isPending ? 'PENDING APPLICATIONS' : 'CONFIRMED GIG',
        style: textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(TextTheme textTheme, String title) {
    return Text(
      title,
      style: textTheme.labelSmall?.copyWith(
        color: AppColors.textSecondary,
        letterSpacing: 3,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.electricAmber),
              const SizedBox(width: 8),
              Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
