part of 'contest_leaderboard_bloc.dart';

@immutable
sealed class ContestLeaderboardEvent {}

final class ContestLeaderboardStarted extends ContestLeaderboardEvent {
  final String contestUrl;
  ContestLeaderboardStarted(this.contestUrl);
}
