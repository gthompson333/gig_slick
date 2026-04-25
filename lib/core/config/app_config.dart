import 'package:injectable/injectable.dart';

@singleton
class AppConfig {
  static const String _defaultPerformerWebBaseUrl = 'http://localhost:5859';
  
  String get performerWebBaseUrl {
    return const String.fromEnvironment(
      'PERFORMER_WEB_BASE_URL',
      defaultValue: _defaultPerformerWebBaseUrl,
    );
  }
}
