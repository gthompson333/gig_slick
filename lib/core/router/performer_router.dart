import 'package:go_router/go_router.dart';
import '../../features/performer_web/presentation/performer_apply_page.dart';

final GoRouter performerRouter = GoRouter(
  initialLocation: '/', // fallback if needed
  routes: [
    GoRoute(
      path: '/v/:venueId/g/:gigId',
      builder: (context, state) {
        final venueId = state.pathParameters['venueId'] ?? 'Unknown Venue';
        final gigId = state.pathParameters['gigId'] ?? '';
        return PerformerApplyPage(venueId: venueId, gigId: gigId);
      },
    ),
    // Route for venue only
    GoRoute(
      path: '/v/:venueId',
      builder: (context, state) {
        final venueId = state.pathParameters['venueId'] ?? 'Unknown Venue';
        return PerformerApplyPage(venueId: venueId, gigId: '');
      },
    ),
    // Fallback route in case the URL doesn't match the format
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const PerformerApplyPage(venueId: 'Unknown Venue', gigId: '');
      },
    ),
  ],
);
