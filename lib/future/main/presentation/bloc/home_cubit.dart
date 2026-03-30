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
  }) : super(const HomeState());

  Future<void> loadHomeData() async {
    emit(const HomeState(
      isDailyLoading: true,
      isProblemsLoading: true,
      isContestsLoading: true,
      isActivityLoading: true,
      isInfoLoading: true,
    ));

    // Fire all requests concurrently — each updates the state as it resolves.
    await Future.wait([
      _loadDaily(),
      _loadProblems(),
      _loadContests(),
      _loadActivity(),
      _loadInfo(),
    ]);
  }

  Future<void> _loadDaily() async {
    final result = await getDailyProblems();
    result.fold(
      (daily) => emit(state.copyWith(dailyProblem: daily, isDailyLoading: false)),
      (_) => emit(state.copyWith(isDailyLoading: false)),
    );
  }

  Future<void> _loadProblems() async {
    final result = await getProblems(page: 1, limit: 5);
    result.fold(
      (problems) => emit(state.copyWith(trendingProblems: problems, isProblemsLoading: false)),
      (_) => emit(state.copyWith(isProblemsLoading: false)),
    );
  }

  Future<void> _loadContests() async {
    final result = await getContests(page: 1, limit: 5);
    result.fold(
      (contests) => emit(state.copyWith(
        upcomingContests: contests.where((c) => !c.isPast).toList(),
        isContestsLoading: false,
      )),
      (_) => emit(state.copyWith(isContestsLoading: false)),
    );
  }

  Future<void> _loadActivity() async {
    final result = await getActivityFeed(page: 1, limit: 10);
    result.fold(
      (activity) => emit(state.copyWith(activityFeed: activity, isActivityLoading: false)),
      (_) => emit(state.copyWith(isActivityLoading: false)),
    );
  }

  Future<void> _loadInfo() async {
    final result = await getInfoList();
    result.fold(
      (infos) => emit(state.copyWith(infoList: infos, isInfoLoading: false)),
      (_) => emit(state.copyWith(isInfoLoading: false)),
    );
  }
}
