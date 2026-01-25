part of 'problems_bloc.dart';

@immutable
sealed class ProblemsState {
  const ProblemsState();
}

final class ProblemsInitial extends ProblemsState {
  const ProblemsInitial();
}

final class ProblemsLoading extends ProblemsState {
  const ProblemsLoading();
}

final class ProblemsLoaded extends ProblemsState {
  final List<ProblemEntity> problems;
  final String query;

  const ProblemsLoaded({required this.problems, this.query = ''});
}

final class ProblemsError extends ProblemsState {
  final String message;
  const ProblemsError(this.message);
}
