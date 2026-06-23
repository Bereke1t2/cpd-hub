import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'package:lab_portal/future/main/presentation/bloc/bookmarks/bookmarks_cubit.dart';
import 'package:lab_portal/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:lab_portal/future/main/domain/usecase/like_it.dart';
import 'package:lab_portal/future/main/domain/usecase/dislike_it.dart';
import 'package:lab_portal/future/main/domain/usecase/make_it_solved.dart';
import 'package:lab_portal/future/main/domain/usecase/unmark_solved.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/profile/profile_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/daily_problem/daily_problem_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/users/users_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contest_leaderboard/contest_leaderboard_bloc.dart';
// ---- phase 9: learning ----
import 'package:lab_portal/features/consistency/data/datasources/consistency_data_source.dart';
import 'package:lab_portal/features/practice/data/datasources/mock/mock_practice_data_source.dart';
import 'package:lab_portal/features/practice/data/datasources/practice_data_source.dart';
import 'package:lab_portal/features/practice/data/repository/practice_repository_impl.dart';
import 'package:lab_portal/features/practice/domain/repository/practice_repository.dart';
import 'package:lab_portal/features/practice/domain/service/recommender.dart';
import 'package:lab_portal/features/practice/domain/service/sm2_scheduler.dart';
import 'package:lab_portal/features/practice/domain/service/strength_analyzer.dart';
import 'package:lab_portal/features/practice/domain/usecase/add_to_review.dart';
import 'package:lab_portal/features/practice/domain/usecase/get_review_queue.dart';
import 'package:lab_portal/features/practice/domain/usecase/get_upsolves.dart';
import 'package:lab_portal/features/practice/domain/usecase/save_review_result.dart';
import 'package:lab_portal/features/practice/presentation/bloc/practice/practice_bloc.dart';
import 'package:lab_portal/features/consistency/data/datasources/mock/mock_consistency_data_source.dart';
import 'package:lab_portal/features/consistency/data/repository/consistency_repository_impl.dart';
import 'package:lab_portal/features/consistency/domain/repository/consistency_repository.dart';
import 'package:lab_portal/features/consistency/domain/service/streak_engine.dart';
import 'package:lab_portal/features/consistency/domain/usecase/get_goal.dart';
import 'package:lab_portal/features/consistency/domain/usecase/get_ladders.dart';
import 'package:lab_portal/features/consistency/domain/usecase/get_streak.dart';
import 'package:lab_portal/features/consistency/domain/usecase/save_goal.dart';
import 'package:lab_portal/features/consistency/domain/usecase/save_streak.dart';
import 'package:lab_portal/features/consistency/presentation/bloc/ladder/ladder_bloc.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/goals/goals_cubit.dart';
import 'package:lab_portal/features/consistency/presentation/cubit/streak/streak_cubit.dart';
import 'package:lab_portal/features/learning/data/datasources/learning_data_source.dart';
import 'package:lab_portal/features/learning/data/datasources/mock/mock_learning_data_source.dart';
import 'package:lab_portal/features/learning/data/repository/learning_repository_impl.dart';
import 'package:lab_portal/features/learning/domain/repository/learning_repository.dart';
import 'package:lab_portal/features/learning/domain/service/learning_path_engine.dart';
import 'package:lab_portal/features/learning/domain/usecase/get_lesson.dart';
import 'package:lab_portal/features/learning/domain/usecase/get_topics.dart';
import 'package:lab_portal/features/learning/domain/usecase/get_tracks.dart';
import 'package:lab_portal/features/learning/presentation/bloc/topics/topics_bloc.dart';
import 'package:lab_portal/features/learning/presentation/bloc/tracks/tracks_bloc.dart';
// ---- phase 15: courses ----
import 'package:lab_portal/features/courses/data/datasources/courses_data_source.dart';
import 'package:lab_portal/features/courses/data/datasources/mock/mock_courses_data_source.dart';
import 'package:lab_portal/features/courses/data/repository/courses_repository_impl.dart';
import 'package:lab_portal/features/courses/domain/repository/courses_repository.dart';
import 'package:lab_portal/features/courses/domain/usecase/get_courses.dart';
import 'package:lab_portal/features/courses/domain/usecase/get_course_detail.dart';
import 'package:lab_portal/features/courses/domain/usecase/mark_lesson_complete.dart';
import 'package:lab_portal/features/courses/presentation/bloc/courses/courses_bloc.dart';
import 'package:lab_portal/features/courses/presentation/bloc/course_detail/course_detail_bloc.dart';
// ---- articles ----
import 'package:lab_portal/core/network/external_dio_client.dart';
import 'package:lab_portal/features/articles/data/datasources/articles_data_source.dart';
import 'package:lab_portal/features/articles/data/datasources/mock/mock_articles_data_source.dart';
import 'package:lab_portal/features/articles/data/repository/articles_repository_impl.dart';
import 'package:lab_portal/features/articles/domain/repository/articles_repository.dart';
import 'package:lab_portal/features/articles/domain/usecase/get_articles.dart';
import 'package:lab_portal/features/articles/presentation/bloc/articles_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // ---- core infrastructure ----
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  getIt.registerLazySingleton<BookmarksCubit>(
    () => BookmarksCubit(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<SettingsCubit>(
    () => SettingsCubit(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<TokenStore>(
    () => TokenStore(getIt<FlutterSecureStorage>()),
  );
  getIt.registerLazySingleton<Dio>(
    () => buildDio(getIt<FlutterSecureStorage>()),
  );
  // Separate Dio for external APIs (Codeforces, etc.) — no auth interceptor.
  getIt.registerLazySingleton<Dio>(
    () => createExternalDio(),
    instanceName: 'externalApi',
  );

  // ---- auth feature ----
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>(), getIt<TokenStore>()),
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
    () => RemoteDataSourceImpl(getIt<Dio>(), getIt<TokenStore>()),
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
  getIt.registerFactory(() => LikeIt(getIt<MainRepo>()));
  getIt.registerFactory(() => DislikeIt(getIt<MainRepo>()));
  getIt.registerFactory(() => MakeItSolved(getIt<MainRepo>()));
  getIt.registerFactory(() => UnmarkSolved(getIt<MainRepo>()));

  // ---- blocs ----
  getIt.registerFactory(() => ProblemsBloc(
    getProblems: getIt<GetProblems>(),
    likeIt: getIt<LikeIt>(),
    dislikeIt: getIt<DislikeIt>(),
    makeItSolved: getIt<MakeItSolved>(),
    unmarkSolved: getIt<UnmarkSolved>(),
  ));
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

  // ---- phase 9: learning ----
  getIt.registerLazySingleton<LearningDataSource>(
    () => MockLearningDataSource(),
  );
  getIt.registerLazySingleton<LearningRepository>(
    () => LearningRepositoryImpl(getIt<LearningDataSource>()),
  );
  getIt.registerLazySingleton<LearningPathEngine>(
    () => const LearningPathEngine(),
  );
  getIt.registerFactory(() => GetTopics(getIt<LearningRepository>()));
  getIt.registerFactory(() => GetTracks(getIt<LearningRepository>()));
  getIt.registerFactory(() => GetLesson(getIt<LearningRepository>()));
  getIt.registerFactory(() => TopicsBloc(
        getTopics: getIt<GetTopics>(),
        engine: getIt<LearningPathEngine>(),
      ));
  getIt.registerFactory(() => TracksBloc(getTracks: getIt<GetTracks>()));

  // ---- phase 10: consistency ----
  getIt.registerLazySingleton<ConsistencyDataSource>(
    () => MockConsistencyDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<ConsistencyRepository>(
    () => ConsistencyRepositoryImpl(getIt<ConsistencyDataSource>()),
  );
  getIt.registerLazySingleton<StreakEngine>(() => const StreakEngine());
  getIt.registerFactory(() => GetStreak(getIt<ConsistencyRepository>()));
  getIt.registerFactory(() => SaveStreak(getIt<ConsistencyRepository>()));
  getIt.registerFactory(() => GetGoal(getIt<ConsistencyRepository>()));
  getIt.registerFactory(() => SaveGoal(getIt<ConsistencyRepository>()));
  getIt.registerFactory(() => GetLadders(getIt<ConsistencyRepository>()));
  getIt.registerLazySingleton<StreakCubit>(
    () => StreakCubit(
      getStreak: getIt<GetStreak>(),
      saveStreak: getIt<SaveStreak>(),
      engine: getIt<StreakEngine>(),
    ),
  );
  getIt.registerLazySingleton<GoalsCubit>(
    () => GoalsCubit(
      getGoal: getIt<GetGoal>(),
      saveGoal: getIt<SaveGoal>(),
    ),
  );
  getIt.registerFactory(
    () => LadderBloc(
      getLadders: getIt<GetLadders>(),
      repo: getIt<ConsistencyRepository>(),
    ),
  );

  // ---- phase 11: smart practice ----
  getIt.registerLazySingleton<PracticeDataSource>(
    () => MockPracticeDataSource(getIt<SharedPreferences>()),
  );
  getIt.registerLazySingleton<PracticeRepository>(
    () => PracticeRepositoryImpl(getIt<PracticeDataSource>()),
  );
  getIt.registerLazySingleton<StrengthAnalyzer>(() => const StrengthAnalyzer());
  getIt.registerLazySingleton<Recommender>(() => const Recommender());
  getIt.registerLazySingleton<Sm2Scheduler>(() => const Sm2Scheduler());
  getIt.registerFactory(() => GetReviewQueue(getIt<PracticeRepository>()));
  getIt.registerFactory(() => GetUpsolves(getIt<PracticeRepository>()));
  getIt.registerFactory(
    () => SaveReviewResult(getIt<PracticeRepository>(),
        scheduler: getIt<Sm2Scheduler>()),
  );
  getIt.registerFactory(
    () => AddToReview(getIt<PracticeRepository>(),
        scheduler: getIt<Sm2Scheduler>()),
  );
  getIt.registerFactory(
    () => PracticeBloc(
      getReviewQueue: getIt<GetReviewQueue>(),
      getUpsolves: getIt<GetUpsolves>(),
      saveReviewResult: getIt<SaveReviewResult>(),
      addToReview: getIt<AddToReview>(),
      repo: getIt<PracticeRepository>(),
      analyzer: getIt<StrengthAnalyzer>(),
      recommender: getIt<Recommender>(),
      scheduler: getIt<Sm2Scheduler>(),
    ),
  );

  // ---- phase 15: courses ----
  getIt.registerLazySingleton<CoursesDataSource>(
    () => MockCoursesDataSource(),
  );
  getIt.registerLazySingleton<CoursesRepository>(
    () => CoursesRepositoryImpl(dataSource: getIt<CoursesDataSource>()),
  );
  getIt.registerFactory(() => GetCourses(getIt<CoursesRepository>()));
  getIt.registerFactory(
      () => GetCourseDetail(getIt<CoursesRepository>()));
  getIt.registerFactory(
      () => MarkLessonComplete(getIt<CoursesRepository>()));
  getIt.registerFactory(
    () => CoursesBloc(getCourses: getIt<GetCourses>()),
  );
  getIt.registerFactory(
    () => CourseDetailBloc(
      getCourseDetail: getIt<GetCourseDetail>(),
      markLessonComplete: getIt<MarkLessonComplete>(),
    ),
  );

  // ---- articles ----
  getIt.registerLazySingleton<ArticlesDataSource>(
    // Swap for live API: CodeforcesArticlesDataSource(dio: getIt<Dio>(instanceName: 'externalApi'))
    () => MockArticlesDataSource(),
  );
  getIt.registerLazySingleton<ArticlesRepository>(
    () => ArticlesRepositoryImpl(dataSource: getIt<ArticlesDataSource>()),
  );
  getIt.registerFactory(() => GetArticles(getIt<ArticlesRepository>()));
  getIt.registerFactory(
    () => ArticlesBloc(getArticles: getIt<GetArticles>()),
  );
}
