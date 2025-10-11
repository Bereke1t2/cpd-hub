
import 'package:dartz/dartz.dart';
import 'package:lab_portal/future/main/domain/entitiy/info_entitity.dart';
import 'package:lab_portal/future/main/domain/entitiy/user_entity.dart';

import '../../../../core/failure.dart';
import '../entitiy/contest_entitiy.dart';
import '../entitiy/daily_problem_entitiy.dart';
import '../entitiy/problem_entitiy.dart';

abstract class MainRepo {

  Future<Either<DailyProblemEntitiy , Failure>> getDailyProblems();
  Future<Either<List<ContestEntitiy>, Failure>> getContests();
  Future<Either<List<ProblemEntity>, Failure>> getProblems();
  Future<Either<UserEntity, Failure>> getProfile();
  Future<Either<InfoEntity, Failure>> getInfo();
  Future<Either<void , Failure>> likeProblem(String problemId);
  Future<Either<void , Failure>> dislikeProblem(String problemId);
  Future<Either<void , Failure>> markProblemAsSolved(String problemId);
  Future<Either<void , Failure>> unmarkProblemAsSolved(String problemId);

}
