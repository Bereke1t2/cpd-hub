import '../../domain/entitiy/leaderboard_entry_entity.dart';

class LeaderboardEntryModel extends LeaderboardEntryEntity {
  const LeaderboardEntryModel({
    required super.rank,
    required super.username,
    required super.rating,
    required super.score,
    required super.penalty,
    required super.problemsSolved,
  });

  factory LeaderboardEntryModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryModel(
      rank: json['rank'] ?? 0,
      username: json['username'] ?? '',
      rating: json['rating'] ?? 0,
      score: json['score'] ?? 0,
      penalty: json['penalty'] ?? 0,
      problemsSolved:
          (json['problemsSolved'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'username': username,
      'rating': rating,
      'score': score,
      'penalty': penalty,
      'problemsSolved': problemsSolved,
    };
  }
}
