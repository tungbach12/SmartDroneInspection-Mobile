import 'package:flutter/foundation.dart' show kIsWeb;

/// Environment configuration injected via --dart-define. Never hardcode URLs.
class AppEnvironment {
  static const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_configuredApiBaseUrl.isNotEmpty) return _configuredApiBaseUrl;
    return kIsWeb
        ? 'http://localhost:8080/api/v1'
        : 'http://10.0.2.2:8080/api/v1';
  }

  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
}
