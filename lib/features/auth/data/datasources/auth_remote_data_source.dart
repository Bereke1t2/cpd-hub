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
    required String confirmPassword,
  });
  Future<AuthUserModel> me();
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  final TokenStore _tokenStore;

  AuthRemoteDataSourceImpl(this._dio, this._tokenStore);

  // POST /api/auth/login
  // Backend domain.LoginRequest: { email, password }
  // Note: backend uses email as the "username" key in the DB query.
  @override
  Future<AuthTokenModel> login(String email, String password) async {
    final res = await _dio.post(
      UrlConstants.loginUrl,
      data: {'email': email, 'password': password},
    );
    final json = res.data as Map<String, dynamic>;
    final token = AuthTokenModel.fromJson(json);
    final user = (json['user'] as Map<String, dynamic>?) ?? {};
    await _tokenStore.saveUser(
      username: (user['username'] ?? email) as String,
      fullName: (user['fullName'] ?? '') as String,
      email: email,
    );
    return token;
  }

  // POST /api/auth/signup
  // Backend domain.SignupRequest: { fullName, email, password, confirmPassword }
  // Note: backend has NO username field — it uses email as the internal username.
  // We still accept username from the caller for caching but do not send it.
  @override
  Future<AuthTokenModel> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final res = await _dio.post(
      UrlConstants.signupUrl,
      data: {
        'fullName': fullName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword, // required by backend validation
      },
    );
    final json = res.data as Map<String, dynamic>;
    final token = AuthTokenModel.fromJson(json);
    final user = (json['user'] as Map<String, dynamic>?) ?? {};
    // Backend returns email as username in AuthResponse.
    await _tokenStore.saveUser(
      username: (user['username'] ?? email) as String,
      fullName: (user['fullName'] ?? fullName) as String,
      email: email,
    );
    return token;
  }

  // No /me endpoint in the Go backend — read from TokenStore cache set on login/signup.
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

  // No logout endpoint — token is cleared locally in the repository.
  @override
  Future<void> logout() async {}
}
