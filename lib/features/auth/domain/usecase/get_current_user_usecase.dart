import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/auth_user_entity.dart';
import '../repository/auth_repository.dart';

class GetCurrentUser {
  final AuthRepository repo;
  GetCurrentUser(this.repo);

  Future<Either<AuthUserEntity, Failure>> call() => repo.getCurrentUser();
}
