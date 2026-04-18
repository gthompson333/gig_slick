import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection.dart';
import '../../../core/theme/app_colors.dart';

import '../bloc/create_slot_bloc.dart';
import '../bloc/create_slot_event.dart';
import '../bloc/create_slot_state.dart';
import 'date_selector.dart';
import 'payout_section.dart';
import 'genre_selection.dart';
import 'schedule_details.dart';
import 'venue_notes.dart';
import 'performer_preview_card.dart';

class CreateSlotPage extends StatelessWidget {
  const CreateSlotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CreateSlotBloc>(),
      child: const CreateSlotView(),
    );
  }
}

class CreateSlotView extends StatelessWidget {
  const CreateSlotView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<CreateSlotBloc, CreateSlotState>(
      listenWhen: (previous, current) => !previous.isSuccess && current.isSuccess,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: AppColors.textTertiary),
                          onPressed: () => context.pop(),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'CREATE SLOT',
                              style: textTheme.labelSmall?.copyWith(
                                color: AppColors.electricAmber,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 48), // Spacer to center the logo row
                      ],
                    ),
                  ),
                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          DateSelector(),
                          SizedBox(height: 32),
                          PayoutSection(),
                          SizedBox(height: 32),
                          GenreSelection(),
                          SizedBox(height: 32),
                          ScheduleDetails(),
                          SizedBox(height: 24),
                          VenueNotes(),
                          SizedBox(height: 40),
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
                      AppColors.surfaceLow.withValues(alpha: 0.0),
                      AppColors.surfaceLow.withValues(alpha: 0.95),
                      AppColors.surfaceLow,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
                child: BlocBuilder<CreateSlotBloc, CreateSlotState>(
                  builder: (context, state) {
                    final canSubmit = state.selectedDate != null && !state.isSubmitting;

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
                              ? () => context.read<CreateSlotBloc>().add(
                                    const CreateSlotEvent.submitRequested(),
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
                              : Text(
                                  'ACTIVATE & SHARE',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0,
                                  ),
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
