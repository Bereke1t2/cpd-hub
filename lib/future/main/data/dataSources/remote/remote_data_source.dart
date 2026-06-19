import 'package:dio/dio.dart';

import 'package:lab_portal/core/error/exceptions.dart';
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
  Future<InfoModel> getInfo();
  Future<List<ContestModel>> getContests();
  Future<UserModel> getProfile();
  Future<List<UserModel>> getUsers();
  Future<List<LeaderboardEntryModel>> getContestLeaderboard(String contestUrl);
  Future<void> likeProblem(String problemId);
  Future<void> dislikeProblem(String problemId);
  Future<void> markProblemAsSolved(String problemId);
  Future<void> unmarkProblemAsSolved(String problemId);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final Dio _dio;
  RemoteDataSourceImpl(this._dio);

  // ---- helpers ----

  List<T> _parseList<T>(
    dynamic data,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList();
    }
    // Django paginated response: { "results": [...] }
    if (data is Map<String, dynamic> && data['results'] is List) {
      return (data['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map(fromJson)
          .toList();
    }
    return [];
  }

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    throw const ServerException('Unexpected response format');
  }

  // ---- user ----

  @override
  Future<UserModel> getUserInfo() async {
    final res = await _dio.get(UrlConstants.getUserInfoUrl);
    return UserModel.fromJson(_asMap(res.data));
  }

  @override
  Future<UserModel> getProfile() async {
    final res = await _dio.get(UrlConstants.getProfileUrl);
    return UserModel.fromJson(_asMap(res.data));
  }

  @override
  Future<List<UserModel>> getUsers() async {
    final res = await _dio.get(UrlConstants.getUsersUrl);
    return _parseList(res.data, UserModel.fromJson);
  }

  // ---- problems ----

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

  @override
  Future<void> likeProblem(String problemId) async {
    await _dio.post(
      UrlConstants.likeProblemUrl,
      data: {'problem_id': problemId},
    );
  }

  @override
  Future<void> dislikeProblem(String problemId) async {
    await _dio.post(
      UrlConstants.dislikeProblemUrl,
      data: {'problem_id': problemId},
    );
  }

  @override
  Future<void> markProblemAsSolved(String problemId) async {
    await _dio.post(
      UrlConstants.markProblemAsSolvedUrl,
      data: {'problem_id': problemId},
    );
  }

  @override
  Future<void> unmarkProblemAsSolved(String problemId) async {
    await _dio.post(
      UrlConstants.unmarkProblemAsSolvedUrl,
      data: {'problem_id': problemId},
    );
  }

  // ---- contests ----

  @override
  Future<List<ContestModel>> getContests() async {
    final res = await _dio.get(UrlConstants.getContestsUrl);
    return _parseList(res.data, ContestModel.fromJson);
  }

  @override
  Future<List<LeaderboardEntryModel>> getContestLeaderboard(
    String contestUrl,
  ) async {
    final res = await _dio.get(
      UrlConstants.getContestLeaderboardUrl,
      queryParameters: {'contest_url': contestUrl},
    );
    return _parseList(res.data, LeaderboardEntryModel.fromJson);
  }

  // ---- info ----

  @override
  Future<InfoModel> getInfo() async {
    final res = await _dio.get(UrlConstants.getInfoUrl);
    return InfoModel.fromJson(_asMap(res.data));
  }
}
