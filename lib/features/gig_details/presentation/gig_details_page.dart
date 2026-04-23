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
  final String venueName;

  const GigDetailsPage({
    super.key,
    required this.gig,
    required this.gigLink,
    required this.venueName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GigDetailsBloc>(),
      child: GigDetailsView(gig: gig, gigLink: gigLink, venueName: venueName),
    );
  }
}

class GigDetailsView extends StatefulWidget {
  final Gig gig;
  final String gigLink;
  final String venueName;

  const GigDetailsView({
    super.key,
    required this.gig,
    required this.gigLink,
    required this.venueName,
  });

  @override
  State<GigDetailsView> createState() => _GigDetailsViewState();
}

class _GigDetailsViewState extends State<GigDetailsView> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.gig.venueNotes);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Color accentColor;
    switch (widget.gig.status) {
      case GigStatus.draft:
        accentColor = AppColors.slateGray;
        break;
      case GigStatus.live:
        accentColor = AppColors.electricAmber;
        break;
      case GigStatus.pending:
        accentColor = AppColors.electricAmber;
        break;
      case GigStatus.confirmed:
        accentColor = AppColors.kineticCyan;
        break;
    }

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
          live: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gig is now LIVE!'),
                backgroundColor: AppColors.electricAmber,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop();
          },
          notesUpdated: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venue notes updated'),
                backgroundColor: AppColors.surfaceHigh,
                behavior: SnackBarBehavior.floating,
              ),
            );
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
                widget.venueName,
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
                    _buildStatusBadge(
                      accentColor,
                      widget.gig.status,
                      textTheme,
                    ),
                    const SizedBox(height: 16),

                    // Date header
                    Text(
                      DateFormat('EEEE, MMMM d, yyyy').format(widget.gig.date),
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
                          widget.gig.loadInTime,
                        ),
                        const SizedBox(width: 24),
                        _buildDetailItem(
                          context,
                          Icons.timer_rounded,
                          'SET TIME',
                          widget.gig.setTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Financial Section
                    _buildSectionHeader(textTheme, 'FINANCIALS'),
                    const SizedBox(height: 16),
                    _buildCard(
                      child: _buildInfoRow(
                        'Base Guarantee',
                        '\$${widget.gig.baseGuarantee.toStringAsFixed(0)}',
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Venue Notes Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader(textTheme, 'VENUE NOTES'),
                        if (_notesController.text != widget.gig.venueNotes)
                          TextButton(
                            onPressed: () {
                              context.read<GigDetailsBloc>().add(
                                    GigDetailsEvent.venueNotesUpdated(
                                      widget.gig.id,
                                      _notesController.text,
                                    ),
                                  );
                            },
                            child: const Text(
                              'SAVE NOTES',
                              style: TextStyle(
                                color: AppColors.electricAmber,
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCard(
                      child: TextField(
                        controller: _notesController,
                        maxLines: null,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Add venue notes...',
                          hintStyle: TextStyle(color: AppColors.textTertiary),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Target Genres Section
                    if (widget.gig.genres.isNotEmpty) ...[
                      _buildSectionHeader(textTheme, 'GENRES'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.gig.genres.map((genre) {
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

                    if (widget.gig.status != GigStatus.draft) ...[
                      _buildSectionHeader(textTheme, 'INVITATION'),
                      const SizedBox(height: 16),
                      PerformerLinkCard(linkUrl: widget.gigLink),
                    ] else ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            context.read<GigDetailsBloc>().add(
                                  GigDetailsEvent.publishRequested(
                                    widget.gig.id,
                                  ),
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricAmber,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Go Live!',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
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
                      extra: {
                        'venueId': widget.gig.venueId,
                        'gig': widget.gig,
                      },
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
              bloc.add(GigDetailsEvent.deleteRequested(widget.gig.id));
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

  Widget _buildStatusBadge(Color color, GigStatus status, TextTheme textTheme) {
    String statusText;
    switch (status) {
      case GigStatus.draft:
        statusText = 'DRAFT GIG';
        break;
      case GigStatus.live:
        statusText = 'LIVE GIG';
        break;
      case GigStatus.pending:
        statusText = 'PENDING APPLICATIONS';
        break;
      case GigStatus.confirmed:
        statusText = 'CONFIRMED GIG';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
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
