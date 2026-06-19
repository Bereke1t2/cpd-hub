import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/auth_user_entity.dart';
import '../repository/auth_repository.dart';

class Login {
  final AuthRepository repo;
  Login(this.repo);

  Future<Either<AuthUserEntity, Failure>> call(String email, String password) =>
      repo.login(email, password);
}
