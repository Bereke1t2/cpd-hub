import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/exceptions.dart';
import 'package:cpd_hub/core/failure.dart';
import 'package:cpd_hub/core/network.dart';
import 'package:cpd_hub/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:cpd_hub/future/main/domain/entitiy/activity_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/attendance_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/contest_entitiy.dart';
import 'package:cpd_hub/future/main/domain/entitiy/daily_problem_entitiy.dart';
import 'package:cpd_hub/future/main/domain/entitiy/heatmap_entry_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/info_entitity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/leaderboard_entry_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/problem_entitiy.dart';
import 'package:cpd_hub/future/main/domain/entitiy/rating_point_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/submission_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';
import 'package:cpd_hub/future/main/domain/repository/main_repo.dart';

class MainRepoImpl implements MainRepo {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MainRepoImpl({required this.remoteDataSource, required this.networkInfo});

  Future<Either<T, Failure>> _guardedCall<T>(Future<T> Function() call) async {
    try {
      final result = await call();
      return Left(result);
    } on UnauthorizedException catch (e) {
      return Right(AuthenticationFailure(e.message));
    } on NotFoundException catch (e) {
      return Right(NotFoundFailure(e.message));
    } on ServerException catch (e) {
      return Right(ServerFailure(e.message));
    } on Exception catch (e) {
      return Right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<List<ProblemEntity>, Failure>> getProblems() async {
    return _guardedCall(() => remoteDataSource.getProblems());
  }

  @override
  Future<Either<DailyProblemEntitiy, Failure>> getDailyProblems() async {
    return _guardedCall(() => remoteDataSource.getDailyProblems());
  }

  @override
  Future<Either<List<ContestEntitiy>, Failure>> getContests() async {
    return _guardedCall(() => remoteDataSource.getContests());
  }

  @override
  Future<Either<UserEntity, Failure>> getProfile(String username) async {
    return _guardedCall(() => remoteDataSource.getProfile(username));
  }

  @override
  Future<Either<InfoEntity, Failure>> getInfo() async {
    return _guardedCall(() => remoteDataSource.getInfo());
  }

  @override
  Future<Either<void, Failure>> likeProblem(String problemId) async {
    return _guardedCall(() => remoteDataSource.likeProblem(problemId));
  }

  @override
  Future<Either<void, Failure>> dislikeProblem(String problemId) async {
    return _guardedCall(() => remoteDataSource.dislikeProblem(problemId));
  }

  @override
  Future<Either<void, Failure>> markProblemAsSolved(String problemId) async {
    return _guardedCall(() => remoteDataSource.markProblemAsSolved(problemId));
  }

  @override
  Future<Either<void, Failure>> unmarkProblemAsSolved(String problemId) async {
    return _guardedCall(
      () => remoteDataSource.unmarkProblemAsSolved(problemId),
    );
  }

  @override
  Future<Either<List<UserEntity>, Failure>> getUsers() async {
    return _guardedCall(() => remoteDataSource.getUsers());
  }

  @override
  Future<Either<List<LeaderboardEntryEntity>, Failure>> getLeaderboard(
    String contestId,
  ) async {
    return _guardedCall(() => remoteDataSource.getLeaderboard(contestId));
  }

  @override
  Future<Either<List<ActivityEntity>, Failure>> getActivityFeed() async {
    return _guardedCall(() => remoteDataSource.getActivityFeed());
  }

  @override
  Future<Either<List<AttendanceEntity>, Failure>> getAttendance(
    String username,
    int month,
    int year,
  ) async {
    return _guardedCall(
      () => remoteDataSource.getAttendance(username, month, year),
    );
  }

  @override
  Future<Either<List<HeatmapEntryEntity>, Failure>> getHeatmap(
    String username,
    int month,
    int year,
  ) async {
    return _guardedCall(
      () => remoteDataSource.getHeatmap(username, month, year),
    );
  }

  @override
  Future<Either<List<RatingPointEntity>, Failure>> getRatingHistory(
    String username,
  ) async {
    return _guardedCall(() => remoteDataSource.getRatingHistory(username));
  }

  @override
  Future<Either<List<SubmissionEntity>, Failure>> getSubmissions(
    String username,
  ) async {
    return _guardedCall(() => remoteDataSource.getSubmissions(username));
  }

  @override
  Future<Either<List<InfoEntity>, Failure>> getInfoList() async {
    return _guardedCall(() => remoteDataSource.getInfoList());
  }
}
