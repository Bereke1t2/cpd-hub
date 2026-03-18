import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cpd_hub/core/url_constants.dart';
import 'package:cpd_hub/core/exceptions.dart';

class AuthResult {
  final String token;
  final String username;
  final String fullName;
  final String email;

  AuthResult({
    required this.token,
    required this.username,
    required this.fullName,
    required this.email,
  });

  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    return AuthResult(
      token: json['token'] as String? ?? '',
      username: user['username'] as String? ?? '',
      fullName: user['fullName'] as String? ?? '',
      email: user['email'] as String? ?? '',
    );
  }
}

class AuthService {
  final http.Client client;

  String? _token;
  String? _currentUsername;

  AuthService({required this.client});

  String? get token => _token;
  String? get currentUsername => _currentUsername;
  bool get isLoggedIn => _token != null;

  Map<String, String> get _baseHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse(UrlConstants.login),
      headers: _baseHeaders,
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final result = AuthResult.fromJson(data);
      _token = result.token;
      _currentUsername = result.username;
      return result;
    }

    final body = _tryDecodeError(response.body);
    if (response.statusCode == 401) {
      throw UnauthorizedException(body);
    }
    throw ServerException(body, statusCode: response.statusCode);
  }

  Future<AuthResult> signup({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await client.post(
      Uri.parse(UrlConstants.signup),
      headers: _baseHeaders,
      body: json.encode({
        'fullName': fullName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final result = AuthResult.fromJson(data);
      _token = result.token;
      _currentUsername = result.username;
      return result;
    }

    final body = _tryDecodeError(response.body);
    if (response.statusCode == 401) {
      throw UnauthorizedException(body);
    }
    throw ServerException(body, statusCode: response.statusCode);
  }

  void logout() {
    _token = null;
    _currentUsername = null;
  }

  String _tryDecodeError(String body) {
    try {
      final data = json.decode(body) as Map<String, dynamic>;
      return data['message'] as String? ??
          data['error'] as String? ??
          'Request failed';
    } catch (_) {
      return body.isNotEmpty ? body : 'Request failed';
    }
  }
}
