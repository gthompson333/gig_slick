import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection.dart';
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // TopAppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.bolt,
                    color: Color(0xFFFFBF00),
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'The Commonwealth',
                    style: TextStyle(
                      color: Color(0xFFFFBF00),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Plus Jakarta Sans',
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFFBF00)),
                    ),
                    loading: () => const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFFBF00)),
                    ),
                    loaded: (slots, magicLink) => SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          MagicLinkCard(linkUrl: magicLink),
                          ScheduledSlotsFeed(slots: slots),
                          const SizedBox(height: 100), // Padding for FAB
                        ],
                      ),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await context.push<bool>('/create-slot');
          if (result == true && context.mounted) {
            context.read<DashboardBloc>().add(const DashboardEvent.loadRequested());
          }
        },
        backgroundColor: const Color(0xFFFFBF00),
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
