import 'package:http/http.dart' as http;
import 'package:cpd_hub/core/auth_service.dart';
import 'package:cpd_hub/core/network.dart';
import 'package:cpd_hub/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:cpd_hub/future/main/data/repository/main_repo.dart';
import 'package:cpd_hub/future/main/domain/repository/main_repo.dart';
import 'package:cpd_hub/future/main/domain/usecase/dislike_it.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_activity_feed.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_attendance.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_contests.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_daily_problm.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_heatmap.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_info_list.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_leaderboard.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_problems.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_profile.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_rating_history.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_submissions.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_users.dart';
import 'package:cpd_hub/future/main/domain/usecase/like_it.dart';
import 'package:cpd_hub/future/main/domain/usecase/make_it_solved.dart';
import 'package:cpd_hub/future/main/presentation/bloc/contest_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/home_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/leaderboard_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/problems_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/profile_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/users_cubit.dart';
import 'package:cpd_hub/future/learning/presentation/bloc/roadmap_cubit.dart';

class Injection {
  static final Injection _instance = Injection._internal();
  factory Injection() => _instance;
  Injection._internal();

  // Core
  late final http.Client httpClient;
  late final NetworkInfo networkInfo;
  late final AuthService authService;

  // Data Sources
  late final RemoteDataSource remoteDataSource;

  // Repository
  late final MainRepo mainRepo;

  // Use Cases
  late final GetProblems getProblems;
  late final GetDailyProblems getDailyProblems;
  late final GetContests getContests;
  late final GetProfile getProfile;
  late final LikeIt likeIt;
  late final DislikeIt dislikeIt;
  late final MakeItSolved makeItSolved;
  late final GetUsers getUsers;
  late final GetLeaderboard getLeaderboard;
  late final GetActivityFeed getActivityFeed;
  late final GetAttendance getAttendance;
  late final GetHeatmap getHeatmap;
  late final GetRatingHistory getRatingHistory;
  late final GetSubmissions getSubmissions;
  late final GetInfoList getInfoList;

  // Cubits
  late final HomeCubit homeCubit;
  late final ProblemsCubit problemsCubit;
  late final ContestCubit contestCubit;
  late final LeaderboardCubit leaderboardCubit;
  late final UsersCubit usersCubit;
  late final ProfileCubit profileCubit;
  late final RoadmapCubit roadmapCubit;

  void init() {
    // Core
    httpClient = http.Client();
    networkInfo = NetworkInfoImpl();
    authService = AuthService(client: httpClient);

    // Data Source
    remoteDataSource = RemoteDataSourceImpl(
      client: httpClient,
      authService: authService,
    );

    // Repository
    mainRepo = MainRepoImpl(
      remoteDataSource: remoteDataSource,
      networkInfo: networkInfo,
    );

    // Use Cases
    getProblems = GetProblems(mainRepo);
    getDailyProblems = GetDailyProblems(mainRepo);
    getContests = GetContests(mainRepo);
    getProfile = GetProfile(mainRepo);
    likeIt = LikeIt(mainRepo);
    dislikeIt = DislikeIt(mainRepo);
    makeItSolved = MakeItSolved(mainRepo);
    getUsers = GetUsers(mainRepo);
    getLeaderboard = GetLeaderboard(mainRepo);
    getActivityFeed = GetActivityFeed(mainRepo);
    getAttendance = GetAttendance(mainRepo);
    getHeatmap = GetHeatmap(mainRepo);
    getRatingHistory = GetRatingHistory(mainRepo);
    getSubmissions = GetSubmissions(mainRepo);
    getInfoList = GetInfoList(mainRepo);

    // Cubits
    homeCubit = HomeCubit(
      getDailyProblems: getDailyProblems,
      getProblems: getProblems,
      getContests: getContests,
      getActivityFeed: getActivityFeed,
      getInfoList: getInfoList,
    );

    problemsCubit = ProblemsCubit(
      getProblems: getProblems,
      likeIt: likeIt,
      dislikeIt: dislikeIt,
      makeItSolved: makeItSolved,
    );

    contestCubit = ContestCubit(getContests: getContests);
    leaderboardCubit = LeaderboardCubit(getLeaderboard: getLeaderboard);
    usersCubit = UsersCubit(getUsers: getUsers);

    profileCubit = ProfileCubit(
      getProfile: getProfile,
      getHeatmap: getHeatmap,
      getRatingHistory: getRatingHistory,
      getAttendance: getAttendance,
      getSubmissions: getSubmissions,
    );

    roadmapCubit = RoadmapCubit()..loadMockCurriculum();
  }
}
