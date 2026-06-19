import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/auth_user_entity.dart';
import '../repository/auth_repository.dart';

class Register {
  final AuthRepository repo;
  Register(this.repo);

  Future<Either<AuthUserEntity, Failure>> call({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) =>
      repo.register(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
      );
}
