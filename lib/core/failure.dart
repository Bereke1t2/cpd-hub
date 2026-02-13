class Failure {
  final String message;
  Failure(this.message);
  @override
  String toString() => 'Failure: $message';
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}
class CacheFailure extends Failure {
  CacheFailure(super.message);
}
class NetworkFailure extends Failure {
  NetworkFailure(super.message);
}
class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}
class AuthenticationFailure extends Failure {
  AuthenticationFailure(super.message);
}
class AuthorizationFailure extends Failure {
  AuthorizationFailure(super.message);
}
class NotFoundFailure extends Failure {
  NotFoundFailure(super.message);
}
class TimeoutFailure extends Failure {
  TimeoutFailure(super.message);
}
class ConflictFailure extends Failure {
  ConflictFailure(super.message);
}
class UnprocessableEntityFailure extends Failure {
  UnprocessableEntityFailure(super.message);
}