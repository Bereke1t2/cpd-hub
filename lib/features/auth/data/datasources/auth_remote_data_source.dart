import 'package:dio/dio.dart';
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
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<AuthTokenModel> login(String email, String password) async {
    final res = await _dio.post(
      UrlConstants.loginUrl,
      data: {'email': email, 'password': password},
    );
    return AuthTokenModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<AuthTokenModel> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post(
      UrlConstants.registerUrl,
      data: {
        'username': username,
        'full_name': fullName,
        'email': email,
        'password': password,
      },
    );
    return AuthTokenModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<AuthUserModel> me() async {
    final res = await _dio.get(UrlConstants.getUserInfoUrl);
    return AuthUserModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<void> logout() async {
    await _dio.post(UrlConstants.logoutUrl);
  }
}
