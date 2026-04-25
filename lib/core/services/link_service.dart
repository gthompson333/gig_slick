import 'package:injectable/injectable.dart';
import '../config/app_config.dart';

@lazySingleton
class LinkService {
  final AppConfig _appConfig;

  LinkService(this._appConfig);

  String generateGigLink(String venueId, String gigId) {
    final baseUrl = _appConfig.performerWebBaseUrl;
    final sanitizedBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;
    return '$sanitizedBaseUrl/v/$venueId/g/$gigId';
  }

  String generateVenueLink(String venueId) {
    final baseUrl = _appConfig.performerWebBaseUrl;
    final sanitizedBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;
    return '$sanitizedBaseUrl/v/$venueId';
  }
}
