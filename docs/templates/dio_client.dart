// lib/core/network/dio_client.dart
//
// Dio HTTP client with auth + error interceptors (Phase 2).
// Register in get_it:  getIt.registerLazySingleton<Dio>(() => buildDio(getIt<TokenStore>()));

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../error/exceptions.dart';
import '../storage/token_store.dart';

Dio buildDio(TokenStore tokenStore) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeoutMs),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  // Attach bearer token to every request.
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokenStore.readAccess();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      // Translate DioException -> our typed exceptions so the repo can map to Failure.
      onError: (e, handler) {
        handler.reject(_mapError(e));
      },
    ),
  );

  if (AppConfig.enableHttpLogs) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  return dio;
}

DioException _mapError(DioException e) {
  // Connectivity / timeout
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return e.copyWith(error: const NetworkException());
  }

  final status = e.response?.statusCode;
  final AppException mapped = switch (status) {
    401 => const UnauthorizedException(),
    404 => const NotFoundException(),
    422 || 400 => ValidationException(
        _msg(e) ?? 'Validation failed',
        (e.response?.data is Map) ? e.response!.data as Map<String, dynamic> : null,
      ),
    _ => ServerException(_msg(e) ?? 'Server error', status),
  };
  return e.copyWith(error: mapped);
}

String? _msg(DioException e) {
  final data = e.response?.data;
  if (data is Map && data['detail'] is String) return data['detail'] as String;
  if (data is Map && data['message'] is String) return data['message'] as String;
  return null;
}
