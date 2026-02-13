import 'package:dartz/dartz.dart';
import 'package:cpd_hub/core/failure.dart';
import '../entitiy/leaderboard_entry_entity.dart';
import '../repository/main_repo.dart';

class GetLeaderboard {
  final MainRepo repository;
  GetLeaderboard(this.repository);

  Future<Either<List<LeaderboardEntryEntity>, Failure>> call(String contestId) async {
    return await repository.getLeaderboard(contestId);
  }
}
