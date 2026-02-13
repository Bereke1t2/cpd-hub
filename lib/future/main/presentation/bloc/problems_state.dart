part of 'problems_cubit.dart';

abstract class ProblemsState extends Equatable {
  const ProblemsState();
  @override
  List<Object?> get props => [];
}

class ProblemsInitial extends ProblemsState {}
class ProblemsLoading extends ProblemsState {}

class ProblemsLoaded extends ProblemsState {
  final List<ProblemEntity> problems;
  const ProblemsLoaded(this.problems);
  @override
  List<Object?> get props => [problems];
}

class ProblemsError extends ProblemsState {
  final String message;
  const ProblemsError(this.message);
  @override
  List<Object?> get props => [message];
}
