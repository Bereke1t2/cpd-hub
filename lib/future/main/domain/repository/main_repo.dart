
import 'package:dartz/dartz.dart';
import 'package:cpd_hub/future/main/domain/entitiy/info_entitity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';

import '../../../../core/failure.dart';
import '../entitiy/activity_entity.dart';
import '../entitiy/attendance_entity.dart';
import '../entitiy/contest_entitiy.dart';
import '../entitiy/daily_problem_entitiy.dart';
import '../entitiy/heatmap_entry_entity.dart';
import '../entitiy/leaderboard_entry_entity.dart';
import '../entitiy/problem_entitiy.dart';
import '../entitiy/rating_point_entity.dart';
import '../entitiy/submission_entity.dart';

abstract class MainRepo {

  Future<Either<DailyProblemEntitiy , Failure>> getDailyProblems();
  Future<Either<List<ContestEntitiy>, Failure>> getContests();
  Future<Either<List<ProblemEntity>, Failure>> getProblems();
  Future<Either<UserEntity, Failure>> getProfile(String username);
  Future<Either<InfoEntity, Failure>> getInfo();
  Future<Either<void , Failure>> likeProblem(String problemId);
  Future<Either<void , Failure>> dislikeProblem(String problemId);
  Future<Either<void , Failure>> markProblemAsSolved(String problemId);
  Future<Either<void , Failure>> unmarkProblemAsSolved(String problemId);

  // New methods
  Future<Either<List<UserEntity>, Failure>> getUsers();
  Future<Either<List<LeaderboardEntryEntity>, Failure>> getLeaderboard(String contestId);
  Future<Either<List<ActivityEntity>, Failure>> getActivityFeed();
  Future<Either<List<AttendanceEntity>, Failure>> getAttendance(String username, int month, int year);
  Future<Either<List<HeatmapEntryEntity>, Failure>> getHeatmap(String username, int month, int year);
  Future<Either<List<RatingPointEntity>, Failure>> getRatingHistory(String username);
  Future<Either<List<SubmissionEntity>, Failure>> getSubmissions(String username);
  Future<Either<List<InfoEntity>, Failure>> getInfoList();
}
