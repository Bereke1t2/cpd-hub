part of 'streak_cubit.dart';

abstract class StreakState extends Equatable {
  const StreakState();
  @override
  List<Object?> get props => [];
}

class StreakInitial extends StreakState {
  const StreakInitial();
}

class StreakLoaded extends StreakState {
  final StreakEntity streak;
  const StreakLoaded(this.streak);
  @override
  List<Object?> get props => [streak];
}
