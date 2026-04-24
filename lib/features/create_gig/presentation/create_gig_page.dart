import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../dashboard/data/entities/gig.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection.dart';
import '../../../core/theme/app_colors.dart';

import '../bloc/create_gig_bloc.dart';
import '../bloc/create_gig_event.dart';
import '../bloc/create_gig_state.dart';
import 'date_selector.dart';
import 'payout_section.dart';
import 'schedule_details.dart';
import 'venue_notes.dart';
import 'genre_selection.dart';
import 'performer_preview_card.dart';

class CreateGigPage extends StatelessWidget {
  final String venueId;
  final Gig? initialGig;

  const CreateGigPage({super.key, required this.venueId, this.initialGig});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CreateGigBloc>()
            ..add(CreateGigEvent.started(venueId, initialGig: initialGig)),
      child: const CreateGigView(),
    );
  }
}

class CreateGigView extends StatelessWidget {
  const CreateGigView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<CreateGigBloc, CreateGigState>(
      listenWhen: (previous, current) =>
          !previous.isSuccess && current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          context.pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceLow,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  // Branded Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () => context.pop(),
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
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/images/logo.png', height: 18),
                            const SizedBox(width: 8),
                            BlocBuilder<CreateGigBloc, CreateGigState>(
                              builder: (context, state) {
                                return Text(
                                  state.gigId != null
                                      ? 'EDIT GIG'
                                      : 'NEW GIG',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: AppColors.electricAmber,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.w900,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                          ],
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                context.read<CreateGigBloc>().add(
                                      const CreateGigEvent.submitRequested(),
                                    );
                              },
                              child: BlocBuilder<CreateGigBloc, CreateGigState>(
                                builder: (context, state) {
                                  if (state.isSubmitting) {
                                    return const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.electricAmber,
                                      ),
                                    );
                                  }
                                  return const Text(
                                    'SAVE',
                                    style: TextStyle(
                                      color: AppColors.electricAmber,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 12,
                                      letterSpacing: 1,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          DateSelector(),
                          SizedBox(height: 32),
                          PayoutSection(),
                          SizedBox(height: 32),
                          ScheduleDetails(),
                          SizedBox(height: 24),
                          VenueNotes(),
                          SizedBox(height: 32),
                          GenreSelection(),
                          SizedBox(height: 48),
                          PerformerPreviewCard(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Floating Submission Bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.surfaceLow.withOpacity(0.0),
                      AppColors.surfaceLow.withOpacity(0.95),
                      AppColors.surfaceLow,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
                child: BlocBuilder<CreateGigBloc, CreateGigState>(
                  builder: (context, state) {
                    final canSubmit = !state.isSubmitting;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              state.errorMessage!,
                              style: textTheme.bodyMedium?.copyWith(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ElevatedButton(
                          onPressed: canSubmit
                              ? () => context.read<CreateGigBloc>().add(
                                  const CreateGigEvent.submitRequested(),
                                )
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.electricAmber,
                            disabledBackgroundColor: AppColors.surfaceHigh,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            minimumSize: const Size(double.infinity, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 3,
                                  ),
                                )
                              : BlocBuilder<CreateGigBloc, CreateGigState>(
                                  builder: (context, state) {
                                    return Text(
                                      state.gigId != null
                                          ? 'SAVE CHANGES'
                                          : 'ACTIVATE & SHARE',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 2.0,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
