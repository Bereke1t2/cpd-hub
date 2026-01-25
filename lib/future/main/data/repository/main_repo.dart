import 'package:dartz/dartz.dart';
import 'package:lab_portal/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:lab_portal/future/main/data/model/contest_model.dart';
import 'package:lab_portal/future/main/data/model/info_model.dart';
import 'package:lab_portal/future/main/data/model/problem_model.dart';
import 'package:lab_portal/future/main/data/model/user_model.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_users_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contests_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_daily_problem_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_problems_data_source.dart';
import 'package:lab_portal/future/main/domain/entitiy/user_entity.dart';

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

  MainRepoImpl(
    this.remoteDataSource,
    this.network,
    this.mockUsersDataSource,
    this.mockProblemsDataSource,
    this.mockContestsDataSource,
    this.mockDailyProblemDataSource,
  );

  @override
  Future<Either<void, Failure>> dislikeProblem(String problemId) async {
    if (!(await network.isConnected)) {
      return right(NetworkFailure("No Internet Connection"));
    }
    try {
      final result = await remoteDataSource.dislikeProblem(problemId);
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> likeProblem(String problemId) async {
    if (!(await network.isConnected)) {
      return right(NetworkFailure("No Internet Connection"));
    }
    try {
      final result = await remoteDataSource.likeProblem(problemId);
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<InfoModel, Failure>> getInfo() async {
    if (!(await network.isConnected)) {
      return Future.value(right(NetworkFailure("No Internet Connection")));
    }
    try {
      final result = await remoteDataSource.getInfo();
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<List<ProblemModel>, Failure>> getProblems() async {
    try {
      final result = await mockProblemsDataSource.getProblems();
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<UserModel, Failure>> getProfile() async {
    if (!(await network.isConnected)) {
      return Future.value(right(NetworkFailure("No Internet Connection")));
    }
    try {
      final result = await remoteDataSource.getProfile();
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<List<ContestModel>, Failure>> getContests() async {
    try {
      final result = await mockContestsDataSource.getContests();
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<DailyProblemModel, Failure>> getDailyProblems() async {
    try {
      final result = await mockDailyProblemDataSource.getDailyProblem();
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> markProblemAsSolved(String problemId) async {
    if (!(await network.isConnected)) {
      return right(NetworkFailure("No Internet Connection"));
    }
    try {
      final result = await remoteDataSource.markProblemAsSolved(problemId);
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<void, Failure>> unmarkProblemAsSolved(String problemId) async {
    if (!(await network.isConnected)) {
      return right(NetworkFailure("No Internet Connection"));
    }
    try {
      final result = await remoteDataSource.unmarkProblemAsSolved(problemId);
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<List<UserEntity>, Failure>> getUsers() async {
    // Users are currently mocked in data-layer (as requested).
    // When API is ready, replace this with remoteDataSource.getUsers().
    try {
      final result = await mockUsersDataSource.getUsers();
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }
}