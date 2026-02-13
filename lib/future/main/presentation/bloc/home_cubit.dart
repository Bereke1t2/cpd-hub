import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/activity_entity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/contest_entitiy.dart';
import 'package:cpd_hub/future/main/domain/entitiy/daily_problem_entitiy.dart';
import 'package:cpd_hub/future/main/domain/entitiy/info_entitity.dart';
import 'package:cpd_hub/future/main/domain/entitiy/problem_entitiy.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_activity_feed.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_contests.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_daily_problm.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_info_list.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_problems.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetDailyProblems getDailyProblems;
  final GetProblems getProblems;
  final GetContests getContests;
  final GetActivityFeed getActivityFeed;
  final GetInfoList getInfoList;

  HomeCubit({
    required this.getDailyProblems,
    required this.getProblems,
    required this.getContests,
    required this.getActivityFeed,
    required this.getInfoList,
  }) : super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());

    final dailyResult = await getDailyProblems();
    final problemsResult = await getProblems();
    final contestsResult = await getContests();
    final activityResult = await getActivityFeed();
    final infoResult = await getInfoList();

    DailyProblemEntitiy? daily;
    List<ProblemEntity> problems = [];
    List<ContestEntitiy> contests = [];
    List<ActivityEntity> activity = [];
    List<InfoEntity> infos = [];

    dailyResult.fold((l) => daily = l, (_) {});
    problemsResult.fold((l) => problems = l, (_) {});
    contestsResult.fold((l) => contests = l, (_) {});
    activityResult.fold((l) => activity = l, (_) {});
    infoResult.fold((l) => infos = l, (_) {});

    emit(HomeLoaded(
      dailyProblem: daily,
      trendingProblems: problems,
      upcomingContests: contests.where((c) => !c.isPast).toList(),
      activityFeed: activity,
      infoList: infos,
    ));
  }
}
