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
    return LeaderboardEntryModel(
      position: json['position'] ?? 0,
      username: json['username'] ?? '',
      solved: json['solved'] ?? 0,
      penalty: json['penalty'] ?? 0,
      oldRating: json['oldRating'] ?? 0,
      newRating: json['newRating'] ?? 0,
    );
  }
}
