class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException(this.message, {this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class UnauthorizedException extends ServerException {
  UnauthorizedException([super.message = 'Unauthorized'])
      : super(statusCode: 401);
}

class NotFoundException extends ServerException {
  NotFoundException([super.message = 'Not found'])
      : super(statusCode: 404);
}
