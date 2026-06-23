import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure persistence for JWT tokens and cached user profile.
class TokenStore {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  static const _kUsername = 'cached_username';
  static const _kFullName = 'cached_full_name';
  static const _kEmail = 'cached_email';
  static const _kCodeforcesHandle = 'cached_cf_handle';

  final FlutterSecureStorage _storage;

  TokenStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({required String access, String? refresh}) async {
    await _storage.write(key: _kAccess, value: access);
    if (refresh != null) {
      await _storage.write(key: _kRefresh, value: refresh);
    }
  }

  Future<void> saveUser({
    required String username,
    required String fullName,
    String email = '',
    String codeforcesHandle = '',
  }) async {
    await _storage.write(key: _kUsername, value: username);
    await _storage.write(key: _kFullName, value: fullName);
    await _storage.write(key: _kEmail, value: email);
    if (codeforcesHandle.isNotEmpty) {
      await _storage.write(
          key: _kCodeforcesHandle, value: codeforcesHandle);
    }
  }

  Future<String?> readUsername() => _storage.read(key: _kUsername);
  Future<String?> readFullName() => _storage.read(key: _kFullName);
  Future<String?> readEmail() => _storage.read(key: _kEmail);
  Future<String?> readCodeforcesHandle() =>
      _storage.read(key: _kCodeforcesHandle);

  Future<String?> readAccess() => _storage.read(key: _kAccess);
  Future<String?> readRefresh() => _storage.read(key: _kRefresh);

  Future<bool> get hasToken async {
    final t = await readAccess();
    return t != null && t.isNotEmpty;
  }

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
    await _storage.delete(key: _kUsername);
    await _storage.delete(key: _kFullName);
    await _storage.delete(key: _kEmail);
    await _storage.delete(key: _kCodeforcesHandle);
  }
}
