import 'config/app_config.dart';

/// All API paths for the Go/Gin backend.
/// Routes registered in internal/delivery/httpdelivery/routes.go.
/// No trailing slashes — Gin is exact-match by default.
class UrlConstants {
  UrlConstants._();

  static String get _base => AppConfig.apiBaseUrl;

  // ── Auth ─────────────────────────────────────────────────────────────────
  // POST  /api/auth/login   body: { email, password }
  //                         → { token, user: { username, fullName } }
  static String get loginUrl => '$_base/auth/login';

  // POST  /api/auth/signup  body: { username, fullName, email, password }
  //                         → { token, user: { username, fullName } }
  static String get signupUrl => '$_base/auth/signup';

  // ── Problems ─────────────────────────────────────────────────────────────
  // GET   /api/problems     → [{id, problemId, title, difficulty, topicTags,
  //                            numberOfLikes, numberOfDislikes, problemUrl,
  //                            isLiked, isDisliked, solved, numberOfSolvedPeople}]
  static String get getProblemsUrl => '$_base/problems';

  // GET   /api/problems/daily → same shape as above
  static String get getDailyProblemUrl => '$_base/problems/daily';

  // POST  /api/problems/:id/like
  // POST  /api/problems/:id/dislike
  // POST  /api/problems/:id/solve
  // DEL   /api/problems/:id/solve
  static String problemLikeUrl(String id) => '$_base/problems/$id/like';
  static String problemDislikeUrl(String id) => '$_base/problems/$id/dislike';
  static String problemSolveUrl(String id) => '$_base/problems/$id/solve';

  // ── Contests ─────────────────────────────────────────────────────────────
  // GET   /api/contests     → [Contest]
  static String get getContestsUrl => '$_base/contests';

  // GET   /api/contests/:id/leaderboard → [LeaderboardEntry]
  // :id = contest.id from the list response (e.g. "codeforces-1932")
  static String contestLeaderboardUrl(String contestId) =>
      '$_base/contests/$contestId/leaderboard';

  // ── Users & Profiles ─────────────────────────────────────────────────────
  // GET   /api/users        → [UserProfile]
  static String get getUsersUrl => '$_base/users';

  // GET   /api/users/profile/:username → UserProfile
  static String userProfileUrl(String username) =>
      '$_base/users/profile/$username';

  // GET   /api/users/profile/:username/analytics/heatmap → [HeatmapEntry]
  static String userHeatmapUrl(String username) =>
      '$_base/users/profile/$username/analytics/heatmap';

  // GET   /api/users/profile/:username/analytics/rating-history → [RatingEntry]
  static String userRatingHistoryUrl(String username) =>
      '$_base/users/profile/$username/analytics/rating-history';

  // GET   /api/users/profile/:username/attendance → [AttendanceEntry]
  static String userAttendanceUrl(String username) =>
      '$_base/users/profile/$username/attendance';

  // GET   /api/users/profile/:username/submissions → [Submission]
  static String userSubmissionsUrl(String username) =>
      '$_base/users/profile/$username/submissions';

  // ── Activity & Info ───────────────────────────────────────────────────────
  // GET   /api/activity     → [Activity]
  static String get getActivityUrl => '$_base/activity';

  // GET   /api/info         → [Info]
  static String get getInfoUrl => '$_base/info';
}
