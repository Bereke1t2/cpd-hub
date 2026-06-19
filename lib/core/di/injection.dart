import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:lab_portal/core/network.dart';
import 'package:lab_portal/core/network/dio_client.dart';
import 'package:lab_portal/core/storage/token_store.dart';
import 'package:lab_portal/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lab_portal/features/auth/data/repository/auth_repository_impl.dart';
import 'package:lab_portal/features/auth/domain/repository/auth_repository.dart';
import 'package:lab_portal/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:lab_portal/features/auth/domain/usecase/login_usecase.dart';
import 'package:lab_portal/features/auth/domain/usecase/logout_usecase.dart';
import 'package:lab_portal/features/auth/domain/usecase/register_usecase.dart';
import 'package:lab_portal/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:lab_portal/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:lab_portal/features/auth/presentation/bloc/session/session_bloc.dart';
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
import 'package:lab_portal/future/main/domain/usecase/get_profile.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/profile/profile_bloc.dart';
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

  // ---- auth feature ----
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<TokenStore>(),
    ),
  );
  getIt.registerFactory(() => Login(getIt<AuthRepository>()));
  getIt.registerFactory(() => Register(getIt<AuthRepository>()));
  getIt.registerFactory(() => Logout(getIt<AuthRepository>()));
  getIt.registerFactory(() => GetCurrentUser(getIt<AuthRepository>()));

  // SessionBloc is a singleton — one instance for the lifetime of the app.
  getIt.registerLazySingleton<SessionBloc>(
    () => SessionBloc(
      getCurrentUser: getIt<GetCurrentUser>(),
      logout: getIt<Logout>(),
    ),
  );
  getIt.registerFactory(
    () => LoginBloc(login: getIt<Login>()),
  );
  getIt.registerFactory(
    () => RegisterBloc(register: getIt<Register>()),
  );

  // ---- main remote data source ----
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

  // ---- main repository ----
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

  // ---- usecases ----
  getIt.registerFactory(() => GetProblems(getIt<MainRepo>()));
  getIt.registerFactory(() => GetContests(getIt<MainRepo>()));
  getIt.registerFactory(() => GetDailyProblems(getIt<MainRepo>()));
  getIt.registerFactory(() => GetUsers(getIt<MainRepo>()));
  getIt.registerFactory(() => GetContestLeaderboard(getIt<MainRepo>()));
  getIt.registerFactory(() => GetProfile(getIt<MainRepo>()));

  // ---- blocs ----
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
  getIt.registerFactory(
    () => ProfileBloc(getProfile: getIt<GetProfile>()),
  );
}
