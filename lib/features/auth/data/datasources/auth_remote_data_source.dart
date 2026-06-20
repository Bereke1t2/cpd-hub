import 'package:dio/dio.dart';
import 'package:lab_portal/core/storage/token_store.dart';
import 'package:lab_portal/core/url_constants.dart';
import '../models/auth_token_model.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> login(String email, String password);
  Future<AuthTokenModel> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
  });
  Future<AuthUserModel> me();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final TokenStore _tokenStore;

  AuthRemoteDataSourceImpl(this._dio, this._tokenStore);

  // Go backend: POST /api/auth/login
  // body:     { email, password }
  // response: { token, user: { username, fullName } }
  @override
  Future<AuthTokenModel> login(String email, String password) async {
    final res = await _dio.post(
      UrlConstants.loginUrl,
      data: {'email': email, 'password': password},
    );
    final json = res.data as Map<String, dynamic>;
    final token = AuthTokenModel.fromJson(json);
    // Cache user identity so me() works offline (no /me endpoint in Go backend).
    final user = json['user'] as Map<String, dynamic>? ?? {};
    await _tokenStore.saveUser(
      username: (user['username'] ?? '') as String,
      fullName: (user['fullName'] ?? '') as String,
      email: email,
    );
    return token;
  }

  // Go backend: POST /api/auth/signup
  // body:     { username, fullName, email, password }
  // response: { token, user: { username, fullName } }
  @override
  Future<AuthTokenModel> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      UrlConstants.signupUrl,
      data: {
        'username': username,
        'fullName': fullName,
        'email': email,
        'password': password,
      },
    );
    final json = res.data as Map<String, dynamic>;
    final token = AuthTokenModel.fromJson(json);
    final user = json['user'] as Map<String, dynamic>? ?? {};
    await _tokenStore.saveUser(
      username: (user['username'] ?? username) as String,
      fullName: (user['fullName'] ?? fullName) as String,
      email: email,
    );
    return token;
  }

  // The Go backend has no /me endpoint. Restore the user from the data
  // cached in TokenStore during the last successful login/signup.
  @override
  Future<AuthUserModel> me() async {
    final storedUsername = await _tokenStore.readUsername();
    final storedFullName = await _tokenStore.readFullName();
    final storedEmail = await _tokenStore.readEmail();
    if (storedUsername == null || storedUsername.isEmpty) {
      throw Exception('No cached user — please sign in again.');
    }
    return AuthUserModel(
      id: storedUsername,
      username: storedUsername,
      email: storedEmail ?? '',
      fullName: storedFullName ?? '',
    );
  }

  // Go backend has no logout endpoint — clearing the local token is sufficient.
  @override
  Future<void> logout() async {}
}
