part of 'daily_problem_bloc.dart';

@immutable
sealed class DailyProblemState {
  const DailyProblemState();
}

final class DailyProblemInitial extends DailyProblemState {
  const DailyProblemInitial();
}

final class DailyProblemLoading extends DailyProblemState {
  const DailyProblemLoading();
}

final class DailyProblemLoaded extends DailyProblemState {
  final DailyProblemEntity daily;
  const DailyProblemLoaded(this.daily);
}

final class DailyProblemError extends DailyProblemState {
  final String message;
  const DailyProblemError(this.message);
}
