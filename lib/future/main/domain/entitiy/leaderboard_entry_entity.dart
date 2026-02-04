import 'package:equatable/equatable.dart';

class LeaderboardEntryEntity extends Equatable {
  final int position;
  final String username;
  final int solved;
  final int penalty;
  final int oldRating;
  final int newRating;

  const LeaderboardEntryEntity({
    required this.position,
    required this.username,
    required this.solved,
    required this.penalty,
    required this.oldRating,
    required this.newRating,
  });

  @override
  List<Object?> get props => [position, username, solved, penalty, oldRating, newRating];
}
