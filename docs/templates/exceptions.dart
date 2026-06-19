// lib/core/error/exceptions.dart
//
// Typed exceptions thrown by the data layer (data sources / Dio interceptor).
// The repository catches these and maps them to `Failure` types (see core/failure.dart).
// Mapping table lives in docs/00-conventions-and-design-system.md §7.

class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

/// 5xx or unexpected server response.
class ServerException extends AppException {
  const ServerException([String message = 'Server error', int? statusCode])
      : super(message, statusCode: statusCode);
}

/// 401 — token missing/expired/invalid.
class UnauthorizedException extends AppException {
  const UnauthorizedException([String message = 'Unauthorized'])
      : super(message, statusCode: 401);
}

/// 404.
class NotFoundException extends AppException {
  const NotFoundException([String message = 'Not found'])
      : super(message, statusCode: 404);
}

/// 422 / 400 with field errors.
class ValidationException extends AppException {
  final Map<String, dynamic>? fieldErrors;
  const ValidationException([String message = 'Validation failed', this.fieldErrors])
      : super(message, statusCode: 422);
}

/// No connectivity / timeout.
class NetworkException extends AppException {
  const NetworkException([String message = 'No internet connection'])
      : super(message);
}
