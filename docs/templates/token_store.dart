// lib/core/storage/token_store.dart
//
// Secure persistence of auth tokens (Phase 3). Backed by flutter_secure_storage.
// Register as a get_it lazy singleton; the Dio auth interceptor reads from it.

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
