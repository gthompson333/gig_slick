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
import '../../../core/services/link_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late TextEditingController _loadInController;
  late TextEditingController _setTimeController;
  late TextEditingController _guaranteeController;
  late List<String> _genres;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController(text: widget.gig.venueNotes);
    _loadInController = TextEditingController(text: widget.gig.loadInTime);
    _setTimeController = TextEditingController(text: widget.gig.setTime);
    _guaranteeController = TextEditingController(
      text: widget.gig.baseGuarantee.toStringAsFixed(0),
    );
    _genres = List.from(widget.gig.genres);
  }

  @override
  void dispose() {
    _notesController.dispose();
    _loadInController.dispose();
    _setTimeController.dispose();
    _guaranteeController.dispose();
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
                content: Text('Gig successfully deleted', style: TextStyle(color: Colors.white)),
              ),
            );
            context.pop();
          },
          live: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Gig is now LIVE!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                backgroundColor: AppColors.electricAmber,
              ),
            );
            context.pop();
          },
          updated: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gig details updated', style: TextStyle(color: Colors.white)),
              ),
            );
            setState(() => _isEditing = false);
          },
          notesUpdated: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Venue notes updated', style: TextStyle(color: Colors.white)),
              ),
            );
            setState(() => _isEditing = false);
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: $message', style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.redAccent,
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
                _isEditing ? 'Edit Gig' : widget.venueName,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              actions: [
                // PENDING & CONFIRMED: no menu — gig is locked
                if (_isEditing) ...[
                  TextButton(
                    onPressed: () {
                      _notesController.text = widget.gig.venueNotes;
                      _loadInController.text = widget.gig.loadInTime;
                      _setTimeController.text = widget.gig.setTime;
                      _guaranteeController.text =
                          widget.gig.baseGuarantee.toStringAsFixed(0);
                      _genres = List.from(widget.gig.genres);
                      setState(() => _isEditing = false);
                    },
                    child: const Text(
                      'CANCEL',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      final hasChanges =
                          _notesController.text != widget.gig.venueNotes ||
                              _loadInController.text != widget.gig.loadInTime ||
                              _setTimeController.text != widget.gig.setTime ||
                              _guaranteeController.text !=
                                  widget.gig.baseGuarantee.toStringAsFixed(0) ||
                              _genres.length != widget.gig.genres.length ||
                              !_genres.every(
                                (g) => widget.gig.genres.contains(g),
                              );

                      if (hasChanges) {
                        context.read<GigDetailsBloc>().add(
                              GigDetailsEvent.gigDetailsUpdated(
                                gigId: widget.gig.id,
                                loadInTime: _loadInController.text,
                                setTime: _setTimeController.text,
                                baseGuarantee: double.tryParse(
                                      _guaranteeController.text,
                                    ) ??
                                    widget.gig.baseGuarantee,
                                genres: _genres,
                                venueNotes: _notesController.text,
                              ),
                            );
                      } else {
                        setState(() => _isEditing = false);
                      }
                    },
                    child: context.watch<GigDetailsBloc>().state.maybeWhen(
                          updating: () => const SizedBox(
                            height: 12,
                            width: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.electricAmber,
                            ),
                          ),
                          orElse: () => const Text(
                            'DONE',
                            style: TextStyle(
                              color: AppColors.electricAmber,
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                  ),
                ] else if (widget.gig.status == GigStatus.draft ||
                           widget.gig.status == GigStatus.live) ...[
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => _showActionsBottomSheet(context),
                    tooltip: 'Actions',
                  ),
                ],
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
                      DateFormat('E, MMM d, yyyy').format(widget.gig.date),
                      style: textTheme.headlineMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    if (widget.gig.status == GigStatus.pending) ...[
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => context.push(
                          '/gig-applications',
                          extra: {'gig': widget.gig},
                        ),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.electricAmber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.electricAmber.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.people_alt_rounded,
                                    color: AppColors.electricAmber,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Review Applications',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: AppColors.electricAmber,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${widget.gig.applicantCount} Pending',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: AppColors.electricAmber.withValues(alpha: 0.8),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.electricAmber,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ] else ...[
                      const SizedBox(height: 32),
                    ],


                    // Detail Grid
                    Row(
                      children: [
                        _buildDetailItem(
                          context,
                          Icons.schedule_rounded,
                          'LOAD-IN',
                          _loadInController.text,
                          controller: _loadInController,
                        ),
                        const SizedBox(width: 24),
                        _buildDetailItem(
                          context,
                          Icons.timer_rounded,
                          'SET TIME',
                          _setTimeController.text,
                          controller: _setTimeController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
 
                    // Financial Section
                    _buildSectionHeader(textTheme, 'FINANCIALS'),
                    const SizedBox(height: 16),
                    _buildCard(
                      child: _isEditing
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Base Guarantee',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    controller: _guaranteeController,
                                    textAlign: TextAlign.end,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                    decoration: const InputDecoration(
                                      prefixText: '\$',
                                      isDense: true,
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : _buildInfoRow(
                              'Base Guarantee',
                              '\$${double.tryParse(_guaranteeController.text)?.toStringAsFixed(0) ?? widget.gig.baseGuarantee.toStringAsFixed(0)}',
                            ),
                    ),
                    const SizedBox(height: 40),

                    // Venue Notes Section
                    _buildSectionHeader(textTheme, 'VENUE NOTES'),
                    const SizedBox(height: 16),
                    _buildCard(
                      child: TextField(
                        controller: _notesController,
                        maxLines: null,
                        readOnly: !_isEditing,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.6,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add venue notes...',
                          hintStyle: const TextStyle(color: AppColors.textTertiary),
                          border: InputBorder.none,
                          fillColor: _isEditing
                              ? Colors.white.withValues(alpha: 0.03)
                              : Colors.transparent,
                          filled: true,
                        ),
                        onChanged: (value) {
                          if (_isEditing) setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Target Genres Section
                    _buildSectionHeader(textTheme, 'GENRES'),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ..._genres.map((genre) {
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  genre,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (_isEditing) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _genres.remove(genre);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                        if (_isEditing)
                          GestureDetector(
                            onTap: () => _showAddGenreDialog(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.electricAmber.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.electricAmber.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    size: 14,
                                    color: AppColors.electricAmber,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ADD',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: AppColors.electricAmber,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // ── Bottom section: status-driven ──────────────────────
                    if (widget.gig.status == GigStatus.draft && !_isEditing) ...[
                      // DRAFT: Go Live! CTA
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            context.read<GigDetailsBloc>().add(
                                  GigDetailsEvent.publishRequested(widget.gig.id),
                                );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.electricAmber,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: context.watch<GigDetailsBloc>().state.maybeWhen(
                                goingLive: () => const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator.adaptive(
                                    strokeWidth: 2,
                                  ),
                                ),
                                orElse: () => const Text(
                                  'Go Live!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ] else if (widget.gig.status == GigStatus.live) ...[
                      // LIVE: Performer link
                      _buildSectionHeader(textTheme, 'INVITATION'),
                      const SizedBox(height: 16),
                      PerformerLinkCard(
                        linkUrl: getIt<LinkService>().generateGigLink(
                            widget.gig.venueId, widget.gig.id),
                        showLink: false,
                        buttonLabel: 'COPY GIG LINK',
                        venueName: widget.venueName,
                      ),
                    ] else if (widget.gig.status == GigStatus.confirmed) ...[
                      // CONFIRMED: Booked Performer card
                      _buildSectionHeader(textTheme, 'BOOKED PERFORMER'),
                      const SizedBox(height: 16),
                      _buildBookedPerformerCard(textTheme),
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
                  onTap: () {
                    Navigator.pop(context); // Dismiss bottom sheet
                    setState(() => _isEditing = true);
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
    String value, {
    TextEditingController? controller,
  }) {
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
          if (_isEditing && controller != null)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: TextField(
                controller: controller,
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  hintText: 'Time...',
                  hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14),
                ),
              ),
            )
          else
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

  Widget _buildBookedPerformerCard(TextTheme textTheme) {
    final name = widget.gig.confirmedPerformerName ?? 'Confirmed Performer';
    final avatarUrl = widget.gig.confirmedPerformerAvatarUrl;
    final socialUrl = widget.gig.appliedPerformerLink;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceMid,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.kineticCyan.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.kineticCyan.withValues(alpha: 0.08),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceHigh,
              border: Border.all(
                color: AppColors.kineticCyan.withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: avatarUrl != null
                ? Image.network(avatarUrl, fit: BoxFit.cover)
                : const Icon(
                    Icons.person_rounded,
                    color: AppColors.kineticCyan,
                    size: 28,
                  ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (socialUrl != null && socialUrl.isNotEmpty)
                  Text(
                    socialUrl,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
              ],
            ),
          ),
          // Social media button
          if (socialUrl != null && socialUrl.isNotEmpty)
            FilledButton.tonal(
              onPressed: () async {
                final uri = Uri.tryParse(socialUrl);
                if (uri != null) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.kineticCyan.withValues(alpha: 0.15),
                foregroundColor: AppColors.kineticCyan,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Social',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
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

  void _showAddGenreDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceHigh,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text(
          'Add Genre',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Enter genre name...',
            hintStyle: TextStyle(color: AppColors.textTertiary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white10),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.electricAmber),
            ),
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
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _genres.add(controller.text.trim());
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.electricAmber,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            child: const Text(
              'ADD',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
