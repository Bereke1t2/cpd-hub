part of 'contest_leaderboard_bloc.dart';

@immutable
sealed class ContestLeaderboardState {
  const ContestLeaderboardState();
}

final class ContestLeaderboardInitial extends ContestLeaderboardState {
  const ContestLeaderboardInitial();
}

final class ContestLeaderboardLoading extends ContestLeaderboardState {
  const ContestLeaderboardLoading();
}

final class ContestLeaderboardLoaded extends ContestLeaderboardState {
  final List<LeaderboardEntryEntity> entries;
  const ContestLeaderboardLoaded(this.entries);
}

final class ContestLeaderboardError extends ContestLeaderboardState {
  final String message;
  const ContestLeaderboardError(this.message);
}
