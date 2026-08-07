import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Compile-time configuration injected via --dart-define.
///
/// Usage:
///   flutter run --dart-define=API_BASE_URL=http://localhost:8000/api --dart-define=USE_MOCK=false
///   flutter run --dart-define-from-file=env/dev.json
///
/// NEVER commit real base URLs or secrets. Keep env/*.json in .gitignore except dev.json.
class AppConfig {
  AppConfig._();

  static const String _envApiBaseUrl = String.fromEnvironment('API_BASE_URL');
  static const bool _useLocalhost = bool.fromEnvironment('USE_LOCALHOST', defaultValue: false);

  /// Base URL of the local Go backend (port 8000).
  /// Dynamically selects:
  /// - `API_BASE_URL` if provided via `--dart-define`
  /// - `http://127.0.0.1:8000/api` if `USE_LOCALHOST` is set (e.g. for physical devices using `adb reverse`)
  /// - `http://10.0.2.2:8000/api` when running on Android emulator
  /// - `http://127.0.0.1:8000/api` for Linux/macOS/Windows/iOS/Web
  static String get apiBaseUrl {
    if (_envApiBaseUrl.isNotEmpty) {
      return _envApiBaseUrl;
    }
    if (_useLocalhost) {
      return 'http://127.0.0.1:8000/api';
    }
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

  /// When true, the repository serves mock data and makes no network calls.
  /// Defaults to false so the app connects to the running local backend.
  static const bool useMock = bool.fromEnvironment(
    'USE_MOCK',
    defaultValue: false,
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
