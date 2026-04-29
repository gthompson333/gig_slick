import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/sign_in/presentation/sign_in_page.dart';
import '../../features/create_venue/presentation/create_venue_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/create_gig/presentation/create_gig_page.dart';
import '../../features/dashboard/data/entities/gig.dart';
import '../../features/gig_details/presentation/gig_details_page.dart';
import '../../features/gig_applications/presentation/applications_page.dart';
import '../../features/gig_applications/presentation/application_details_page.dart';
import '../../features/gig_applications/data/entities/gig_application.dart';

/// A [Listenable] that notifies when a [Stream] emits a value.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/sign-in',
  refreshListenable: GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  redirect: (context, state) {
    // Prevent GoRouter from throwing errors on Firebase Auth redirect links
    if (state.uri.host == 'firebaseauth' || state.uri.path.contains('__/')) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    final isSignIn = state.matchedLocation == '/sign-in';

    if (user != null) {
      if (isSignIn) {
        // If they just logged in, guest users ALWAYS go to create-venue first
        if (user.isAnonymous) {
          return '/create-venue';
        }
        // For phone users, the DashboardPage handles fetching the venue and 
        // showing the appropriate state, but we can default to /dashboard.
        return '/dashboard';
      }
      return null;
    }

    if (user == null && !isSignIn) {
      return '/sign-in';
    }

    return null;
  },
  routes: [
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
      name: '/create-gig',
      path: '/create-gig',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final venueId = extras['venueId'] as String;
        final venueName = extras['venueName'] as String;
        return CreateGigPage(venueId: venueId, venueName: venueName);
      },
    ),
    GoRoute(
      name: '/edit-gig',
      path: '/edit-gig',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final venueId = extras['venueId'] as String;
        final venueName = extras['venueName'] as String;
        final gig = extras['gig'] as Gig;
        return CreateGigPage(
          venueId: venueId,
          venueName: venueName,
          initialGig: gig,
        );
      },
    ),
    GoRoute(
      name: '/gig-details',
      path: '/gig-details',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final gig = extras['gig'] as Gig;
        final gigLink = extras['gigLink'] as String;
        final venueName = extras['venueName'] as String;
        return GigDetailsPage(
          gig: gig,
          gigLink: gigLink,
          venueName: venueName,
        );
      },
    ),
    GoRoute(
      name: '/gig-applications',
      path: '/gig-applications',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final gig = extras['gig'] as Gig;
        return ApplicationsPage(gig: gig);
      },
    ),
    GoRoute(
      name: '/application-details',
      path: '/application-details',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final application = extras['application'] as GigApplication;
        final gig = extras['gig'] as Gig;
        return ApplicationDetailsPage(application: application, gig: gig);
      },
    ),
  ],
);
