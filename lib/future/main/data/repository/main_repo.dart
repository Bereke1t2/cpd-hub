import 'package:dartz/dartz.dart';
import 'package:lab_portal/core/config/app_config.dart';
import 'package:lab_portal/core/error/exceptions.dart';
import 'package:lab_portal/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:lab_portal/future/main/data/model/contest_model.dart';
import 'package:lab_portal/future/main/data/model/info_model.dart';
import 'package:lab_portal/future/main/data/model/problem_model.dart';
import 'package:lab_portal/future/main/data/model/user_model.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_users_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contests_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_daily_problem_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_problems_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contest_leaderboard_data_source.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';
import 'package:lab_portal/future/main/domain/entity/leaderboard_entry_entity.dart';

import '../../../../core/failure.dart';
import '../../../../core/network.dart';
import '../../domain/repository/main_repo.dart';
import '../model/daily_problem_model.dart';

class MainRepoImpl implements MainRepo {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo network;
  final MockUsersDataSource mockUsersDataSource;
  final MockProblemsDataSource mockProblemsDataSource;
  final MockContestsDataSource mockContestsDataSource;
  final MockDailyProblemDataSource mockDailyProblemDataSource;
  final MockContestLeaderboardDataSource mockContestLeaderboardDataSource;

  MainRepoImpl(
    this.remoteDataSource,
    this.network,
    this.mockUsersDataSource,
    this.mockProblemsDataSource,
    this.mockContestsDataSource,
    this.mockDailyProblemDataSource,
    this.mockContestLeaderboardDataSource,
  );

  // ---- helpers ----

  /// Checks connectivity then executes [call], mapping exceptions → Failures.
  /// Convention: Left = success, Right = Failure.
  Future<Either<T, Failure>> _remote<T>(Future<T> Function() call) async {
    if (!(await network.isConnected)) {
      return right(NetworkFailure('No internet connection.'));
    }
    try {
      return left(await call());
    } on UnauthorizedException catch (e) {
      return right(AuthenticationFailure(e.message));
    } on NotFoundException catch (e) {
      return right(NotFoundFailure(e.message));
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

  Future<Either<T, Failure>> _mock<T>(Future<T> Function() call) async {
    try {
      return left(await call());
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  // ---- problems ----

  @override
  Future<Either<List<ProblemModel>, Failure>> getProblems() {
    if (AppConfig.useMock) {
      return _mock(() => mockProblemsDataSource.getProblems());
    }
    return _remote(() => remoteDataSource.getProblems());
  }

  @override
  Future<Either<void, Failure>> likeProblem(String problemId) =>
      _remote(() => remoteDataSource.likeProblem(problemId));

  @override
  Future<Either<void, Failure>> dislikeProblem(String problemId) =>
      _remote(() => remoteDataSource.dislikeProblem(problemId));

  @override
  Future<Either<void, Failure>> markProblemAsSolved(String problemId) =>
      _remote(() => remoteDataSource.markProblemAsSolved(problemId));

  @override
  Future<Either<void, Failure>> unmarkProblemAsSolved(String problemId) =>
      _remote(() => remoteDataSource.unmarkProblemAsSolved(problemId));

  // ---- daily problem ----

  @override
  Future<Either<DailyProblemModel, Failure>> getDailyProblems() {
    if (AppConfig.useMock) {
      return _mock(() => mockDailyProblemDataSource.getDailyProblem());
    }
    return _remote(() => remoteDataSource.getDailyProblems());
  }

  // ---- contests ----

  @override
  Future<Either<List<ContestModel>, Failure>> getContests() {
    if (AppConfig.useMock) {
      return _mock(() => mockContestsDataSource.getContests());
    }
    return _remote(() => remoteDataSource.getContests());
  }

  @override
  Future<Either<List<LeaderboardEntryEntity>, Failure>> getContestLeaderboard(
    String contestUrl,
  ) {
    if (AppConfig.useMock) {
      return _mock(
        () => mockContestLeaderboardDataSource.getLeaderboard(contestUrl),
      );
    }
    return _remote(() => remoteDataSource.getContestLeaderboard(contestUrl));
  }

  // ---- users ----

  @override
  Future<Either<List<UserEntity>, Failure>> getUsers() {
    if (AppConfig.useMock) {
      return _mock(() => mockUsersDataSource.getUsers());
    }
    return _remote(() => remoteDataSource.getUsers());
  }

  // ---- profile ----

  @override
  Future<Either<UserModel, Failure>> getProfile() =>
      _remote(() => remoteDataSource.getProfile());

  // ---- info ----

  @override
  Future<Either<InfoModel, Failure>> getInfo() {
    if (AppConfig.useMock) {
      return Future.value(
        left(const InfoModel(title: 'CPD Hub', description: 'Welcome!')),
      );
    }
    // Backend returns a list; take the first item (or a default).
    return _remote(() async {
      final list = await remoteDataSource.getInfoList();
      if (list.isEmpty) {
        return const InfoModel(title: 'CPD Hub', description: 'Welcome!');
      }
      return list.first;
    });
  }
}
