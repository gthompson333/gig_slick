import 'package:go_router/go_router.dart';
import '../../features/onboarding/presentation/onboarding_page.dart';
import '../../features/sign_in/presentation/sign_in_page.dart';
import '../../features/create_venue/presentation/create_venue_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/create_slot/presentation/create_slot_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
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
      path: '/create-slot',
      builder: (context, state) => const CreateSlotPage(),
    ),
  ],
);
