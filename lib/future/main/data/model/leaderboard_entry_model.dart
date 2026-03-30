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
    final problemsRaw = json['problemsSolved'] ?? json['problems_solved'] ?? json['problems'];
    List<String> problems = [];
    if (problemsRaw is List) {
      problems = problemsRaw.map((e) => e.toString()).toList();
    }
    return LeaderboardEntryModel(
      rank: (json['rank'] is num) ? (json['rank'] as num).toInt() : int.tryParse('${json['rank']}') ?? 0,
      username: json['username']?.toString() ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toInt() : int.tryParse('${json['rating']}') ?? 0,
      score: (json['score'] is num) ? (json['score'] as num).toInt() : int.tryParse('${json['score']}') ?? 0,
      penalty: (json['penalty'] is num) ? (json['penalty'] as num).toInt() : int.tryParse('${json['penalty']}') ?? 0,
      problemsSolved: problems,
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
