import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection.dart';

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
    return BlocListener<CreateSlotBloc, CreateSlotState>(
      listenWhen: (previous, current) => !previous.isSuccess && current.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          context.pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Gradient accents
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.topCenter,
                    radius: 1.5,
                    colors: [
                      Color(0xFF1B1B1B),
                      Colors.black,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Modal Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Color(0xFFFFBF00)),
                        onPressed: () => context.pop(),
                      ),
                      const Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.bolt,
                              color: Color(0xFFFFBF00),
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Create Slot',
                              style: TextStyle(
                                color: Color(0xFFFFBF00),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Plus Jakarta Sans',
                              ),
                            ),
                            SizedBox(width: 48), // Balance for back button
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      bottom: 120, // Padding for floating CTA
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DateSelector(),
                        SizedBox(height: 40),
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
          // Floating Action Bottom Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 24,
                    offset: Offset(0, -12),
                  ),
                ],
              ),
              child: BlocBuilder<CreateSlotBloc, CreateSlotState>(
                builder: (context, state) {
                  final canSubmit = state.selectedDate != null && !state.isSubmitting;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            state.errorMessage!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ElevatedButton(
                        onPressed: canSubmit
                            ? () {
                                context
                                    .read<CreateSlotBloc>()
                                    .add(const CreateSlotEvent.submitRequested());
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFBF00),
                          disabledBackgroundColor:
                              const Color(0xFFFFBF00).withValues(alpha: 0.2),
                          foregroundColor: const Color(0xFF402D00),
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                          shadowColor:
                              const Color(0xFFFFBF00).withValues(alpha: 0.4),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Color(0xFF402D00),
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'ACTIVATE & COPY LINK',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
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
    ));
  }
}
