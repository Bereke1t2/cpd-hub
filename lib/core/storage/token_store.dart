import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure persistence for JWT access + refresh tokens.
/// Backed by flutter_secure_storage (Keychain on iOS, Keystore on Android,
/// libsecret on Linux, Credential Store on Windows).
///
/// Register as a get_it lazy singleton so the Dio auth interceptor and
/// the auth repository share the same instance.
class TokenStore {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  final FlutterSecureStorage _storage;

  TokenStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({required String access, String? refresh}) async {
    await _storage.write(key: _kAccess, value: access);
    if (refresh != null) {
      await _storage.write(key: _kRefresh, value: refresh);
    }
  }

  Future<String?> readAccess() => _storage.read(key: _kAccess);
  Future<String?> readRefresh() => _storage.read(key: _kRefresh);

  Future<bool> get hasToken async {
    final t = await readAccess();
    return t != null && t.isNotEmpty;
  }

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}
