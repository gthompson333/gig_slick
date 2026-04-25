import 'package:go_router/go_router.dart';
import '../../features/performer/presentation/performer_page.dart';

final GoRouter performerRouter = GoRouter(
  initialLocation: '/', // fallback if needed
  routes: [
    GoRoute(
      path: '/:venueName/:gigId',
      builder: (context, state) {
        final venueName = state.pathParameters['venueName'] ?? 'Unknown Venue';
        final gigId = state.pathParameters['gigId'] ?? '';
        return PerformerPage(venueName: venueName, gigId: gigId);
      },
    ),
    // Fallback route in case the URL doesn't match the format
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const PerformerPage(venueName: 'Unknown Venue', gigId: '');
      },
    ),
  ],
);
