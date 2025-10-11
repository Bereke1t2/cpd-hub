

import 'package:dartz/dartz.dart';
import 'package:lab_portal/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:lab_portal/future/main/data/model/contest_model.dart';
import 'package:lab_portal/future/main/data/model/info_model.dart';
import 'package:lab_portal/future/main/data/model/problem_model.dart';
import 'package:lab_portal/future/main/data/model/user_model.dart';

import '../../../../core/failure.dart';
import '../../../../core/network.dart';
import '../../domain/repository/main_repo.dart';
import '../model/daily_problem_model.dart';

class MainRepoImpl implements MainRepo{
  final RemoteDataSource remoteDataSource;
  final NetworkInfo network;

  MainRepoImpl(this.remoteDataSource, this.network);

  @override
  Future<Either<void , Failure>> dislikeProblem(String problemId) async {
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
  Future<Either<void , Failure>> likeProblem(String problemId) async {
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
    if (!(await network.isConnected)) {
      return Future.value(right(NetworkFailure("No Internet Connection")));
    }
    try {
      final result = await remoteDataSource.getProblems();
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
    if (!(await network.isConnected)) {
      return Future.value(right(NetworkFailure("No Internet Connection")));
    }
    try {
      final result = await remoteDataSource.getContests();
      return left(result);
    } catch (e) {
      return right(ServerFailure(e.toString()));
    }
  }
  @override
  Future<Either<DailyProblemModel, Failure>> getDailyProblems() async {
    if (!(await network.isConnected)) {
      return Future.value(right(NetworkFailure("No Internet Connection")));
    }
    try {
      final result = await remoteDataSource.getDailyProblems();
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
}