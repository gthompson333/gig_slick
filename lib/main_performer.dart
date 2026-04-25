import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_web_plugins/url_strategy.dart';

import 'core/theme/app_theme.dart';
import 'core/router/performer_router.dart';
import 'firebase_options.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // Enables clean URLs without the '#'
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  configureDependencies();
  runApp(const PerformerApp());
}

class PerformerApp extends StatelessWidget {
  const PerformerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gig Slick - Apply',
      theme: AppTheme.darkTheme,
      routerConfig: performerRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
