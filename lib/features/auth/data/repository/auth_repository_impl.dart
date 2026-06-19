import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/error/exceptions.dart';
import 'package:lab_portal/core/failure.dart';
import 'package:lab_portal/core/storage/token_store.dart';
import 'package:lab_portal/features/auth/domain/entity/auth_user_entity.dart';
import 'package:lab_portal/features/auth/domain/repository/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStore _tokens;

  AuthRepositoryImpl(this._remote, this._tokens);

  // Checks connectivity isn't needed for auth — the error interceptor
  // already maps timeout/no-connection to NetworkException.
  Future<Either<T, Failure>> _guard<T>(Future<T> Function() call) async {
    try {
      return left(await call());
    } on UnauthorizedException catch (e) {
      return right(AuthenticationFailure(e.message));
    } on ValidationException catch (e) {
      return right(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return right(NetworkFailure(e.message));
    } on AppException catch (e) {
      return right(ServerFailure(e.message));
    } catch (_) {
      return right(ServerFailure('Something went wrong.'));
    }
  }

  @override
  Future<Either<AuthUserEntity, Failure>> login(
    String email,
    String password,
  ) async {
    return _guard(() async {
      final tokens = await _remote.login(email, password);
      await _tokens.saveTokens(
        access: tokens.access,
        refresh: tokens.refresh,
      );
      return _remote.me();
    });
  }

  @override
  Future<Either<AuthUserEntity, Failure>> register({
    required String username,
    required String fullName,
    required String email,
    required String password,
  }) async {
    return _guard(() async {
      final tokens = await _remote.register(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
      );
      await _tokens.saveTokens(
        access: tokens.access,
        refresh: tokens.refresh,
      );
      return _remote.me();
    });
  }

  @override
  Future<Either<AuthUserEntity, Failure>> getCurrentUser() =>
      _guard(() => _remote.me());

  @override
  Future<Either<void, Failure>> logout() async {
    // Always clear local tokens, even if the server call fails.
    try {
      await _remote.logout();
    } catch (_) {}
    await _tokens.clear();
    return left(null);
  }
}
