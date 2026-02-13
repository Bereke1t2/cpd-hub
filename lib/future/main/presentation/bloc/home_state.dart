part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final DailyProblemEntitiy? dailyProblem;
  final List<ProblemEntity> trendingProblems;
  final List<ContestEntitiy> upcomingContests;
  final List<ActivityEntity> activityFeed;
  final List<InfoEntity> infoList;

  const HomeLoaded({
    this.dailyProblem,
    required this.trendingProblems,
    required this.upcomingContests,
    required this.activityFeed,
    required this.infoList,
  });

  @override
  List<Object?> get props => [dailyProblem, trendingProblems, upcomingContests, activityFeed, infoList];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
  @override
  List<Object?> get props => [message];
}
