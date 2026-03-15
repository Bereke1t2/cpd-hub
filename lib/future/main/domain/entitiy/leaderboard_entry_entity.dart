import 'package:equatable/equatable.dart';

class LeaderboardEntryEntity extends Equatable {
  final int rank;
  final String username;
  final int rating;
  final int score;
  final int penalty;
  final List<String> problemsSolved;

  const LeaderboardEntryEntity({
    required this.rank,
    required this.username,
    required this.rating,
    required this.score,
    required this.penalty,
    required this.problemsSolved,
  });

  @override
  List<Object?> get props => [
    rank,
    username,
    rating,
    score,
    penalty,
    problemsSolved,
  ];
}
