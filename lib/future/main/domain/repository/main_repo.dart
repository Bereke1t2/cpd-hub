import 'package:dartz/dartz.dart';
import 'package:lab_portal/future/main/domain/entity/info_entity.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';

import '../../../../core/failure.dart';
import '../entity/contest_entity.dart';
import '../entity/daily_problem_entity.dart';
import '../entity/problem_entity.dart';
import '../entity/leaderboard_entry_entity.dart';

abstract class MainRepo {

  Future<Either<DailyProblemEntity , Failure>> getDailyProblems();
  Future<Either<List<ContestEntity>, Failure>> getContests();
  Future<Either<List<ProblemEntity>, Failure>> getProblems();
  Future<Either<UserEntity, Failure>> getProfile();
  Future<Either<InfoEntity, Failure>> getInfo();
  Future<Either<void , Failure>> likeProblem(String problemId);
  Future<Either<void , Failure>> dislikeProblem(String problemId);
  Future<Either<void , Failure>> markProblemAsSolved(String problemId);
  Future<Either<void , Failure>> unmarkProblemAsSolved(String problemId);
  Future<Either<List<UserEntity>, Failure>> getUsers();
  Future<Either<List<LeaderboardEntryEntity>, Failure>> getContestLeaderboard(
    String contestUrl,
  );

}
