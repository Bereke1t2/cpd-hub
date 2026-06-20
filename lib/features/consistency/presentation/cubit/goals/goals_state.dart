part of 'goals_cubit.dart';

abstract class GoalsState extends Equatable {
  const GoalsState();
  @override
  List<Object?> get props => [];
}

class GoalsInitial extends GoalsState {
  const GoalsInitial();
}

class GoalsLoaded extends GoalsState {
  final GoalEntity goal;
  const GoalsLoaded(this.goal);
  @override
  List<Object?> get props => [goal];
}
