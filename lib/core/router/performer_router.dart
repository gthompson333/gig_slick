import 'package:go_router/go_router.dart';
import '../../features/performer/presentation/performer_page.dart';

final GoRouter performerRouter = GoRouter(
  initialLocation: '/', // fallback if needed
  routes: [
    GoRoute(
      path: '/v/:venueId/g/:gigId',
      builder: (context, state) {
        final venueId = state.pathParameters['venueId'] ?? 'Unknown Venue';
        final gigId = state.pathParameters['gigId'] ?? '';
        return PerformerPage(venueId: venueId, gigId: gigId);
      },
    ),
    // Route for venue only
    GoRoute(
      path: '/v/:venueId',
      builder: (context, state) {
        final venueId = state.pathParameters['venueId'] ?? 'Unknown Venue';
        return PerformerPage(venueId: venueId, gigId: '');
      },
    ),
    // Fallback route in case the URL doesn't match the format
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const PerformerPage(venueId: 'Unknown Venue', gigId: '');
      },
    ),
  ],
);
