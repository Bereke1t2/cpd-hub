part of 'home_cubit.dart';

class HomeState extends Equatable {
  final DailyProblemEntitiy? dailyProblem;
  final List<ProblemEntity> trendingProblems;
  final List<ContestEntitiy> upcomingContests;
  final List<ActivityEntity> activityFeed;
  final List<InfoEntity> infoList;
  final bool isDailyLoading;
  final bool isProblemsLoading;
  final bool isContestsLoading;
  final bool isActivityLoading;
  final bool isInfoLoading;
  final String? error;

  const HomeState({
    this.dailyProblem,
    this.trendingProblems = const [],
    this.upcomingContests = const [],
    this.activityFeed = const [],
    this.infoList = const [],
    this.isDailyLoading = false,
    this.isProblemsLoading = false,
    this.isContestsLoading = false,
    this.isActivityLoading = false,
    this.isInfoLoading = false,
    this.error,
  });

  bool get isFullyLoaded =>
      !isDailyLoading &&
      !isProblemsLoading &&
      !isContestsLoading &&
      !isActivityLoading &&
      !isInfoLoading;

  bool get hasAnyData =>
      dailyProblem != null ||
      trendingProblems.isNotEmpty ||
      upcomingContests.isNotEmpty ||
      activityFeed.isNotEmpty ||
      infoList.isNotEmpty;

  HomeState copyWith({
    DailyProblemEntitiy? dailyProblem,
    List<ProblemEntity>? trendingProblems,
    List<ContestEntitiy>? upcomingContests,
    List<ActivityEntity>? activityFeed,
    List<InfoEntity>? infoList,
    bool? isDailyLoading,
    bool? isProblemsLoading,
    bool? isContestsLoading,
    bool? isActivityLoading,
    bool? isInfoLoading,
    String? error,
  }) {
    return HomeState(
      dailyProblem: dailyProblem ?? this.dailyProblem,
      trendingProblems: trendingProblems ?? this.trendingProblems,
      upcomingContests: upcomingContests ?? this.upcomingContests,
      activityFeed: activityFeed ?? this.activityFeed,
      infoList: infoList ?? this.infoList,
      isDailyLoading: isDailyLoading ?? this.isDailyLoading,
      isProblemsLoading: isProblemsLoading ?? this.isProblemsLoading,
      isContestsLoading: isContestsLoading ?? this.isContestsLoading,
      isActivityLoading: isActivityLoading ?? this.isActivityLoading,
      isInfoLoading: isInfoLoading ?? this.isInfoLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        dailyProblem,
        trendingProblems,
        upcomingContests,
        activityFeed,
        infoList,
        isDailyLoading,
        isProblemsLoading,
        isContestsLoading,
        isActivityLoading,
        isInfoLoading,
        error,
      ];
}
