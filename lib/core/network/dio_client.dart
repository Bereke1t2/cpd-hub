import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../error/exceptions.dart';

/// Builds and returns a configured [Dio] instance.
///
/// Interceptors (applied in order):
///   1. Auth interceptor  — reads the bearer token from secure storage.
///   2. Error interceptor — maps [DioException] to typed [AppException]s
///      so the repository can convert them to domain [Failure]s.
///   3. Log interceptor   — enabled only when AppConfig.enableHttpLogs is true.
///
/// Register in get_it:
///   getIt.registerLazySingleton<Dio>(() => buildDio(getIt<FlutterSecureStorage>()));
Dio buildDio(FlutterSecureStorage storage) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(milliseconds: AppConfig.connectTimeoutMs),
      receiveTimeout: const Duration(milliseconds: AppConfig.receiveTimeoutMs),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // 1. Attach bearer token to every outgoing request.
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        const key = 'access_token';
        final token = await storage.read(key: key);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      // 2. Map DioException → typed AppException before it reaches the repo.
      onError: (e, handler) {
        handler.reject(_mapError(e));
      },
    ),
  );

  // 3. HTTP logging (only when --dart-define=HTTP_LOGS=true).
  if (AppConfig.enableHttpLogs) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  return dio;
}

DioException _mapError(DioException e) {
  // Connectivity / timeout → NetworkException.
  if (e.type == DioExceptionType.connectionError ||
      e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.receiveTimeout ||
      e.type == DioExceptionType.sendTimeout) {
    return e.copyWith(error: const NetworkException());
  }

  final status = e.response?.statusCode;
  final AppException mapped;

  switch (status) {
    case 401:
      mapped = const UnauthorizedException();
    case 404:
      mapped = const NotFoundException();
    case 400:
    case 422:
      mapped = ValidationException(
        _extractMessage(e) ?? 'Validation failed',
        e.response?.data is Map<String, dynamic>
            ? e.response!.data as Map<String, dynamic>
            : null,
      );
    default:
      mapped = ServerException(_extractMessage(e) ?? 'Server error', status);
  }

  return e.copyWith(error: mapped);
}

/// Tries to extract a human-readable message from the response body.
String? _extractMessage(DioException e) {
  final data = e.response?.data;
  if (data is Map) {
    for (final key in ['detail', 'message', 'error']) {
      if (data[key] is String) return data[key] as String;
    }
  }
  return null;
}
