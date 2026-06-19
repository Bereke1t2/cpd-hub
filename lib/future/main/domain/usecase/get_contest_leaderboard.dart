import 'package:dartz/dartz.dart';

import '../../../../core/failure.dart';
import '../entity/leaderboard_entry_entity.dart';
import '../repository/main_repo.dart';

class GetContestLeaderboard {
  final MainRepo repo;
  const GetContestLeaderboard(this.repo);

  Future<Either<List<LeaderboardEntryEntity>, Failure>> call(
    String contestUrl,
  ) {
    return repo.getContestLeaderboard(contestUrl);
  }
}
