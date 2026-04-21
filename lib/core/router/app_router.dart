import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/sign_in/presentation/sign_in_page.dart';
import '../../features/create_venue/presentation/create_venue_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/create_gig/presentation/create_gig_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.matchedLocation == '/onboarding' || state.matchedLocation == '/sign-in';

    if (user != null && isLoggingIn) {
      // TODO: In the future, check if user has a venue and send to /create-venue if not.
      return '/dashboard';
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/sign-in',
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: '/create-venue',
      builder: (context, state) => const CreateVenuePage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/create-gig',
      builder: (context, state) {
        final venueId = state.extra as String;
        return CreateGigPage(venueId: venueId);
      },
    ),
  ],
);
