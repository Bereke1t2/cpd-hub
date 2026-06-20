/// Compile-time configuration injected via --dart-define.
///
/// Usage:
///   flutter run --dart-define=API_BASE_URL=https://staging.cpdhub/api --dart-define=USE_MOCK=false
///   flutter run --dart-define-from-file=env/dev.json
///
/// NEVER commit real base URLs or secrets. Keep env/*.json in .gitignore except dev.json.
class AppConfig {
  AppConfig._();

  /// Base URL of the Go backend (Gin, default :8080).
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://192.168.202.96:8080/api',
  );

  /// When true, the repository serves mock data and makes no network calls.
  /// Defaults to true so the app runs without a backend during development.
  static const bool useMock = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: true,
  );

  /// Enable verbose Dio request/response logging.
  static const bool enableHttpLogs = bool.fromEnvironment(
    'HTTP_LOGS',
    defaultValue: false,
  );

  /// Network timeouts.
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 20000;
}
