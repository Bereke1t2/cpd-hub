import '../../domain/entity/leaderboard_entry_entity.dart';

class LeaderboardEntryModel extends LeaderboardEntryEntity {
  const LeaderboardEntryModel({
    required super.position,
    required super.username,
    required super.solved,
    required super.penalty,
    required super.oldRating,
    required super.newRating,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    // Go backend LeaderboardEntry: rank, username, rating, score, penalty, solvedCount
    // Mobile entity uses: position, username, solved, penalty, oldRating, newRating
    final rating = (json['rating'] ?? 0) as int;
    return LeaderboardEntryModel(
      position: (json['rank'] ?? json['position'] ?? 0) as int,
      username: (json['username'] ?? '') as String,
      solved: (json['score'] ?? json['solvedCount'] ?? json['solved'] ?? 0) as int,
      penalty: (json['penalty'] ?? 0) as int,
      oldRating: (json['oldRating'] ?? rating) as int,
      newRating: (json['newRating'] ?? rating) as int,
    );
  }
}
