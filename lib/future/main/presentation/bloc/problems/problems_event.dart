part of 'problems_bloc.dart';

@immutable
sealed class ProblemsEvent {}

final class ProblemsStarted extends ProblemsEvent {}

final class ProblemsSearchChanged extends ProblemsEvent {
  final String query;
  ProblemsSearchChanged(this.query);
}

final class ProblemLikeToggled extends ProblemsEvent {
  final String problemId;
  ProblemLikeToggled(this.problemId);
}

final class ProblemDislikeToggled extends ProblemsEvent {
  final String problemId;
  ProblemDislikeToggled(this.problemId);
}

final class ProblemSolvedToggled extends ProblemsEvent {
  final String problemId;
  ProblemSolvedToggled(this.problemId);
}
