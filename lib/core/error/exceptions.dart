/// Typed exceptions thrown by the data layer (remote data sources).
/// The repository catches these and maps them to Failure types.
///
/// Mapping:
///   ServerException       → ServerFailure      "Something went wrong. Try again."
///   UnauthorizedException → AuthenticationFailure "Please sign in again."
///   NotFoundException     → NotFoundFailure    "Not found."
///   ValidationException   → ValidationFailure  (field errors forwarded)
///   NetworkException      → NetworkFailure     "No internet connection."

class AppException implements Exception {
  final String message;
  final int? statusCode;
  const AppException(this.message, {this.statusCode});

  @override
  String toString() => '$runtimeType(${statusCode ?? '-'}): $message';
}

/// 5xx or unexpected server error.
class ServerException extends AppException {
  const ServerException([super.message = 'Server error', int? statusCode])
      : super(statusCode: statusCode);
}

/// 401 — token missing, expired, or invalid.
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized'])
      : super(statusCode: 401);
}

/// 404 — resource not found.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Not found'])
      : super(statusCode: 404);
}

/// 400 / 422 — field validation errors from the backend.
class ValidationException extends AppException {
  final Map<String, dynamic>? fieldErrors;
  const ValidationException([
    super.message = 'Validation failed',
    this.fieldErrors,
  ]) : super(statusCode: 422);
}

/// No connectivity, connection timeout, or receive timeout.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}
