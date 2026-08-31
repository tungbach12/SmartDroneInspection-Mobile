/// Environment configuration injected via --dart-define. Never hardcode URLs.
class AppEnvironment {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000/api',
  );

  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
}
