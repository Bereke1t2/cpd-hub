// lib/core/config/app_config.dart
//
// Compile-time configuration injected via --dart-define (Phase 2).
// Run:  flutter run --dart-define=API_BASE_URL=https://staging.cpdhub/api --dart-define=USE_MOCK=false
// Or:   flutter run --dart-define-from-file=env/dev.json
//
// NEVER hardcode production URLs/secrets in source.

class AppConfig {
  AppConfig._();

  /// Base URL of the Django REST backend. Defaults to a safe local value.
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api',
  );

  /// When true, the repository serves mock data and makes no network calls.
  /// Default true so the app runs with no backend during development.
  static const bool useMock = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: true,
  );

  /// Network timeouts (ms).
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 20000;

  /// Enable verbose Dio logging only in debug-like envs.
  static const bool enableHttpLogs = bool.fromEnvironment(
    'HTTP_LOGS',
    defaultValue: false,
  );
}
