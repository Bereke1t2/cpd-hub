// lib/core/di/injection.dart
//
// get_it service locator (Phase 1). Call configureDependencies() once in main()
// before runApp(). Repos + data sources are lazy singletons; BLoCs are factories.

import 'package:get_it/get_it.dart';

// --- existing data sources (mock) ---
import 'package:lab_portal/core/network.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contests_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_daily_problem_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_problems_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_users_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contest_leaderboard_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:lab_portal/future/main/data/repository/main_repo.dart';
import 'package:lab_portal/future/main/domain/repository/main_repo.dart';

// --- usecases ---
import 'package:lab_portal/future/main/domain/usecase/get_contests.dart';
import 'package:lab_portal/future/main/domain/usecase/get_daily_problem.dart';
import 'package:lab_portal/future/main/domain/usecase/get_problems.dart';
import 'package:lab_portal/future/main/domain/usecase/get_users.dart';
import 'package:lab_portal/future/main/domain/usecase/get_contest_leaderboard.dart';

// --- blocs ---
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/daily_problem/daily_problem_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/users/users_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contest_leaderboard/contest_leaderboard_bloc.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  // ---- core ----
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // In Phase 2 this becomes RemoteDataSourceImpl(getIt<Dio>()).
  getIt.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl());

  // ---- mock data sources ----
  getIt.registerLazySingleton<MockUsersDataSource>(() => MockUsersDataSourceImpl());
  getIt.registerLazySingleton<MockProblemsDataSource>(() => MockProblemsDataSourceImpl());
  getIt.registerLazySingleton<MockContestsDataSource>(() => MockContestsDataSourceImpl());
  getIt.registerLazySingleton<MockDailyProblemDataSource>(() => MockDailyProblemDataSourceImpl());
  getIt.registerLazySingleton<MockContestLeaderboardDataSource>(
      () => MockContestLeaderboardDataSourceImpl());

  // ---- repository (single instance shared across the app) ----
  getIt.registerLazySingleton<MainRepo>(() => MainRepoImpl(
        getIt<RemoteDataSource>(),
        getIt<NetworkInfo>(),
        getIt<MockUsersDataSource>(),
        getIt<MockProblemsDataSource>(),
        getIt<MockContestsDataSource>(),
        getIt<MockDailyProblemDataSource>(),
        getIt<MockContestLeaderboardDataSource>(),
      ));

  // ---- usecases ----
  getIt.registerFactory(() => GetProblems(getIt<MainRepo>()));
  getIt.registerFactory(() => GetContests(getIt<MainRepo>()));
  getIt.registerFactory(() => GetDailyProblems(getIt<MainRepo>()));
  getIt.registerFactory(() => GetUsers(getIt<MainRepo>()));
  getIt.registerFactory(() => GetContestLeaderboard(getIt<MainRepo>()));

  // ---- blocs (new instance per screen) ----
  getIt.registerFactory(() => ProblemsBloc(getProblems: getIt<GetProblems>()));
  getIt.registerFactory(() => ContestsBloc(getContests: getIt<GetContests>()));
  getIt.registerFactory(() => DailyProblemBloc(getDailyProblems: getIt<GetDailyProblems>()));
  getIt.registerFactory(() => UsersBloc(getUsers: getIt<GetUsers>()));
  getIt.registerFactory(
      () => ContestLeaderboardBloc(getContestLeaderboard: getIt<GetContestLeaderboard>()));
}
