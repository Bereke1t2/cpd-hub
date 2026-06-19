import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../repository/auth_repository.dart';

class Logout {
  final AuthRepository repo;
  Logout(this.repo);

  Future<Either<void, Failure>> call() => repo.logout();
}
