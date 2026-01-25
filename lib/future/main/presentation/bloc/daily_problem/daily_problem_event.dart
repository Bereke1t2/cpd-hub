part of 'daily_problem_bloc.dart';

@immutable
sealed class DailyProblemEvent {}

final class DailyProblemStarted extends DailyProblemEvent {}
