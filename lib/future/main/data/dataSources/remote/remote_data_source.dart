import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cpd_hub/core/url_constants.dart';
import 'package:cpd_hub/core/exceptions.dart';
import 'package:cpd_hub/core/auth_service.dart';
import '../../model/activity_model.dart';
import '../../model/attendance_model.dart';
import '../../model/contest_model.dart';
import '../../model/daily_problem_model.dart';
import '../../model/heatmap_entry_model.dart';
import '../../model/info_model.dart';
import '../../model/leaderboard_entry_model.dart';
import '../../model/problem_model.dart';
import '../../model/rating_point_model.dart';
import '../../model/submission_model.dart';
import '../../model/user_model.dart';

abstract class RemoteDataSource {
  Future<List<ProblemModel>> getProblems();
  Future<DailyProblemModel> getDailyProblems();
  Future<List<ContestModel>> getContests();
  Future<UserModel> getProfile(String username);
  Future<InfoModel> getInfo();
  Future<void> likeProblem(String problemId);
  Future<void> dislikeProblem(String problemId);
  Future<void> markProblemAsSolved(String problemId);
  Future<void> unmarkProblemAsSolved(String problemId);
  Future<List<UserModel>> getUsers();
  Future<List<LeaderboardEntryModel>> getLeaderboard(String contestId);
  Future<List<ActivityModel>> getActivityFeed();
  Future<List<AttendanceModel>> getAttendance(
    String username,
    int month,
    int year,
  );
  Future<List<HeatmapEntryModel>> getHeatmap(
    String username,
    int month,
    int year,
  );
  Future<List<RatingPointModel>> getRatingHistory(String username);
  Future<List<SubmissionModel>> getSubmissions(String username);
  Future<List<InfoModel>> getInfoList();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;
  final AuthService authService;

  RemoteDataSourceImpl({required this.client, required this.authService});

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (authService.token != null)
          'Authorization': 'Bearer ${authService.token}',
      };

  // ──────────────────── Helpers ────────────────────

  /// Perform a GET, decode as JSON list, and map each element.
  Future<List<T>> _getList<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await client.get(Uri.parse(url), headers: _headers);
    _assertSuccess(response);
    final List<dynamic> data = json.decode(response.body);
    return data
        .map((item) => fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Perform a GET, decode as JSON object, and map.
  Future<T> _getObject<T>(
    String url,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await client.get(Uri.parse(url), headers: _headers);
    _assertSuccess(response);
    return fromJson(json.decode(response.body) as Map<String, dynamic>);
  }

  /// Perform a POST (no body) and assert success.
  Future<void> _postAction(String url) async {
    final response = await client.post(Uri.parse(url), headers: _headers);
    _assertSuccess(response);
  }

  /// Perform a DELETE and assert success.
  Future<void> _deleteAction(String url) async {
    final response = await client.delete(Uri.parse(url), headers: _headers);
    _assertSuccess(response);
  }

  void _assertSuccess(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    final message = _tryDecodeError(response.body);
    switch (response.statusCode) {
      case 401:
        throw UnauthorizedException(message);
      case 404:
        throw NotFoundException(message);
      default:
        throw ServerException(message, statusCode: response.statusCode);
    }
  }

  String _tryDecodeError(String body) {
    try {
      final data = json.decode(body) as Map<String, dynamic>;
      return data['message'] as String? ??
          data['error'] as String? ??
          'Request failed';
    } catch (_) {
      return body.isNotEmpty ? body : 'Request failed';
    }
  }

  // ──────────────────── Problems ────────────────────

  @override
  Future<List<ProblemModel>> getProblems() =>
      _getList(UrlConstants.problems, ProblemModel.fromJson);

  @override
  Future<DailyProblemModel> getDailyProblems() =>
      _getObject(UrlConstants.dailyProblem, DailyProblemModel.fromJson);

  @override
  Future<void> likeProblem(String problemId) =>
      _postAction(UrlConstants.likeProblem(problemId));

  @override
  Future<void> dislikeProblem(String problemId) =>
      _postAction(UrlConstants.dislikeProblem(problemId));

  @override
  Future<void> markProblemAsSolved(String problemId) =>
      _postAction(UrlConstants.solveProblem(problemId));

  @override
  Future<void> unmarkProblemAsSolved(String problemId) =>
      _deleteAction(UrlConstants.solveProblem(problemId));

  // ──────────────────── Contests ────────────────────

  @override
  Future<List<ContestModel>> getContests() =>
      _getList(UrlConstants.contests, ContestModel.fromJson);

  @override
  Future<List<LeaderboardEntryModel>> getLeaderboard(String contestId) =>
      _getList(
        UrlConstants.leaderboard(contestId),
        LeaderboardEntryModel.fromJson,
      );

  // ──────────────────── Users ────────────────────

  @override
  Future<List<UserModel>> getUsers() =>
      _getList(UrlConstants.users, UserModel.fromJson);

  @override
  Future<UserModel> getProfile(String username) =>
      _getObject(UrlConstants.profile(username), UserModel.fromJson);

  // ──────────────────── Activity ────────────────────

  @override
  Future<List<ActivityModel>> getActivityFeed() =>
      _getList(UrlConstants.activityFeed, ActivityModel.fromJson);

  // ──────────────────── Profile Analytics ────────────────────

  @override
  Future<List<HeatmapEntryModel>> getHeatmap(
    String username,
    int month,
    int year,
  ) =>
      _getList(
        '${UrlConstants.heatmap(username)}?month=$month&year=$year',
        HeatmapEntryModel.fromJson,
      );

  @override
  Future<List<RatingPointModel>> getRatingHistory(String username) =>
      _getList(UrlConstants.ratingHistory(username), RatingPointModel.fromJson);

  @override
  Future<List<SubmissionModel>> getSubmissions(String username) =>
      _getList(UrlConstants.submissions(username), SubmissionModel.fromJson);

  @override
  Future<List<AttendanceModel>> getAttendance(
    String username,
    int month,
    int year,
  ) =>
      _getList(
        '${UrlConstants.attendance(username)}?month=$month&year=$year',
        AttendanceModel.fromJson,
      );

  // ──────────────────── Info ────────────────────

  @override
  Future<InfoModel> getInfo() =>
      _getObject(UrlConstants.info, InfoModel.fromJson);

  @override
  Future<List<InfoModel>> getInfoList() =>
      _getList(UrlConstants.info, InfoModel.fromJson);
}
