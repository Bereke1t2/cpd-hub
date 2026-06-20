import 'package:dio/dio.dart';
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

  Future<Either<T, Failure>> _guard<T>(Future<T> Function() call) async {
    try {
      return left(await call());
    } catch (raw) {
      // Dio wraps our AppException inside DioException.error — unwrap it.
      final e = raw is DioException ? (raw.error ?? raw) : raw;

      if (e is UnauthorizedException) {
        return right(AuthenticationFailure(
          e.message.isNotEmpty ? e.message : 'Invalid email or password.',
        ));
      }
      if (e is ValidationException) {
        return right(ValidationFailure(
          e.message.isNotEmpty ? e.message : 'Please check your details.',
        ));
      }
      if (e is NetworkException) {
        return right(NetworkFailure(
          e.message.isNotEmpty ? e.message : 'No internet connection.',
        ));
      }
      if (e is AppException) {
        return right(ServerFailure(
          e.message.isNotEmpty ? e.message : 'Something went wrong.',
        ));
      }
      // DioException with no mapped error (e.g. raw 400 not caught by interceptor).
      if (raw is DioException) {
        final data = raw.response?.data;
        String? msg;
        if (data is Map) {
          msg = (data['message'] ?? data['error']) as String?;
        }
        return right(ServerFailure(
          msg?.isNotEmpty == true ? msg! : 'Something went wrong (${raw.response?.statusCode}).',
        ));
      }
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
    // confirmPassword is required by the Go backend — pass it through.
    String confirmPassword = '',
  }) async {
    return _guard(() async {
      final tokens = await _remote.register(
        username: username,
        fullName: fullName,
        email: email,
        password: password,
        confirmPassword: confirmPassword.isEmpty ? password : confirmPassword,
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
    try {
      await _remote.logout();
    } catch (_) {}
    await _tokens.clear();
    return left(null);
  }
}
