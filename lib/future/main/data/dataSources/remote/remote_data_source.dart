import 'package:dio/dio.dart';
import 'package:lab_portal/core/error/exceptions.dart';
import 'package:lab_portal/core/storage/token_store.dart';
import 'package:lab_portal/core/url_constants.dart';
import '../../model/contest_model.dart';
import '../../model/daily_problem_model.dart';
import '../../model/info_model.dart';
import '../../model/leaderboard_entry_model.dart';
import '../../model/problem_model.dart';
import '../../model/user_model.dart';

abstract class RemoteDataSource {
  Future<UserModel> getUserInfo();
  Future<DailyProblemModel> getDailyProblems();
  Future<List<ProblemModel>> getProblems();
  Future<List<InfoModel>> getInfoList();
  Future<List<ContestModel>> getContests();
  Future<UserModel> getProfile();
  Future<List<UserModel>> getUsers();
  Future<List<LeaderboardEntryModel>> getContestLeaderboard(String contestId);
  Future<void> likeProblem(String problemId);
  Future<void> dislikeProblem(String problemId);
  Future<void> markProblemAsSolved(String problemId);
  Future<void> unmarkProblemAsSolved(String problemId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio;
  final TokenStore _tokenStore;

  RemoteDataSourceImpl(this._dio, this._tokenStore);

  // ── helpers ───────────────────────────────────────────────────────────────

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data is List) {
      return data.whereType<Map<String, dynamic>>().map(fromJson).toList();
    }
    return [];
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw const ServerException('Unexpected response format');
  }

  // ── user / profile ────────────────────────────────────────────────────────

  @override
  Future<UserModel> getUserInfo() async {
    final username = await _tokenStore.readUsername() ?? '';
    if (username.isEmpty) throw const ServerException('Not authenticated');
    final res = await _dio.get(UrlConstants.userProfileUrl(username));
    return UserModel.fromJson(_asMap(res.data));
  }

  @override
  Future<UserModel> getProfile() async {
    final username = await _tokenStore.readUsername() ?? '';
    if (username.isEmpty) throw const ServerException('Not authenticated');
    final res = await _dio.get(UrlConstants.userProfileUrl(username));
    return UserModel.fromJson(_asMap(res.data));
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final res = await _dio.get(UrlConstants.getUsersUrl);
    return _parseList(res.data, UserModel.fromJson);
  }

  // ── problems ──────────────────────────────────────────────────────────────

  @override
  Future<List<ProblemModel>> getProblems() async {
    final res = await _dio.get(UrlConstants.getProblemsUrl);
    return _parseList(res.data, ProblemModel.fromJson);
  }

  @override
  Future<DailyProblemModel> getDailyProblems() async {
    final res = await _dio.get(UrlConstants.getDailyProblemUrl);
    return DailyProblemModel.fromJson(_asMap(res.data));
  }

  // Problem interactions — use path params, not body params.
  // POST /api/problems/:id/like
  @override
  Future<void> likeProblem(String problemId) async {
    await _dio.post(UrlConstants.problemLikeUrl(problemId));
  }

  // POST /api/problems/:id/dislike
  @override
  Future<void> dislikeProblem(String problemId) async {
    await _dio.post(UrlConstants.problemDislikeUrl(problemId));
  }

  // POST /api/problems/:id/solve
  @override
  Future<void> markProblemAsSolved(String problemId) async {
    await _dio.post(UrlConstants.problemSolveUrl(problemId));
  }

  // DELETE /api/problems/:id/solve
  @override
  Future<void> unmarkProblemAsSolved(String problemId) async {
    await _dio.delete(UrlConstants.problemSolveUrl(problemId));
  }

  // ── contests ──────────────────────────────────────────────────────────────

  @override
  Future<List<ContestModel>> getContests() async {
    final res = await _dio.get(UrlConstants.getContestsUrl);
    return _parseList(res.data, ContestModel.fromJson);
  }

  // GET /api/contests/:id/leaderboard
  // contestId = ContestEntity.id (e.g. "codeforces-1932")
  @override
  Future<List<LeaderboardEntryModel>> getContestLeaderboard(
    String contestId,
  ) async {
    final res =
        await _dio.get(UrlConstants.contestLeaderboardUrl(contestId));
    return _parseList(res.data, LeaderboardEntryModel.fromJson);
  }

  // ── info ──────────────────────────────────────────────────────────────────

  @override
  Future<List<InfoModel>> getInfoList() async {
    final res = await _dio.get(UrlConstants.getInfoUrl);
    return _parseList(res.data, InfoModel.fromJson);
  }
}
