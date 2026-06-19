import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:lab_portal/core/network.dart';
import 'package:lab_portal/core/network/dio_client.dart';
import 'package:lab_portal/core/storage/token_store.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contests_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_daily_problem_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_problems_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_users_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contest_leaderboard_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:lab_portal/future/main/data/repository/main_repo.dart';
import 'package:lab_portal/future/main/domain/repository/main_repo.dart';
import 'package:lab_portal/future/main/domain/usecase/get_contests.dart';
import 'package:lab_portal/future/main/domain/usecase/get_daily_problem.dart';
import 'package:lab_portal/future/main/domain/usecase/get_problems.dart';
import 'package:lab_portal/future/main/domain/usecase/get_users.dart';
import 'package:lab_portal/future/main/domain/usecase/get_contest_leaderboard.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/daily_problem/daily_problem_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/users/users_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contest_leaderboard/contest_leaderboard_bloc.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  // ---- core infrastructure ----
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<TokenStore>(
    () => TokenStore(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<Dio>(
    () => buildDio(getIt<FlutterSecureStorage>()),
  );

  // ---- remote data source (uses Dio; mock-flag routing is in the repo) ----
  getIt.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(getIt<Dio>()),
  );

  // ---- mock data sources ----
  getIt.registerLazySingleton<MockUsersDataSource>(
    () => MockUsersDataSourceImpl(),
  );
  getIt.registerLazySingleton<MockProblemsDataSource>(
    () => MockProblemsDataSourceImpl(),
  );
  getIt.registerLazySingleton<MockContestsDataSource>(
    () => MockContestsDataSourceImpl(),
  );
  getIt.registerLazySingleton<MockDailyProblemDataSource>(
    () => MockDailyProblemDataSourceImpl(),
  );
  getIt.registerLazySingleton<MockContestLeaderboardDataSource>(
    () => MockContestLeaderboardDataSourceImpl(),
  );

  // ---- repository (single shared instance) ----
  getIt.registerLazySingleton<MainRepo>(
    () => MainRepoImpl(
      getIt<RemoteDataSource>(),
      getIt<NetworkInfo>(),
      getIt<MockUsersDataSource>(),
      getIt<MockProblemsDataSource>(),
      getIt<MockContestsDataSource>(),
      getIt<MockDailyProblemDataSource>(),
      getIt<MockContestLeaderboardDataSource>(),
    ),
  );

  // ---- usecases (factory: rebuilt cheaply per screen) ----
  getIt.registerFactory(() => GetProblems(getIt<MainRepo>()));
  getIt.registerFactory(() => GetContests(getIt<MainRepo>()));
  getIt.registerFactory(() => GetDailyProblems(getIt<MainRepo>()));
  getIt.registerFactory(() => GetUsers(getIt<MainRepo>()));
  getIt.registerFactory(() => GetContestLeaderboard(getIt<MainRepo>()));

  // ---- blocs (factory: new instance per screen) ----
  getIt.registerFactory(() => ProblemsBloc(getProblems: getIt<GetProblems>()));
  getIt.registerFactory(() => ContestsBloc(getContests: getIt<GetContests>()));
  getIt.registerFactory(
    () => DailyProblemBloc(getDailyProblems: getIt<GetDailyProblems>()),
  );
  getIt.registerFactory(() => UsersBloc(getUsers: getIt<GetUsers>()));
  getIt.registerFactory(
    () => ContestLeaderboardBloc(
      getContestLeaderboard: getIt<GetContestLeaderboard>(),
    ),
  );
}
