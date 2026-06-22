import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/failure.dart';
import '../entity/auth_user_entity.dart';

// Left = success, Right = Failure (repo convention in this codebase).
abstract class AuthRepository {
  Future<Either<AuthUserEntity, Failure>> login(String email, String password);

  Future<Either<AuthUserEntity, Failure>> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
    String confirmPassword,
  });

  Future<Either<AuthUserEntity, Failure>> getCurrentUser();

  Future<Either<void, Failure>> logout();
}
