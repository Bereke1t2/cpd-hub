class UrlConstants {
  static const String baseUrl = 'http://192.168.137.204:8000/api';

  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String signup = '$baseUrl/auth/signup';

  // Problems
  static const String problems = '$baseUrl/problems';
  static const String dailyProblem = '$baseUrl/problems/daily';
  static String problemDetail(String id) => '$baseUrl/problems/$id';
  static String likeProblem(String id) => '$baseUrl/problems/$id/like';
  static String dislikeProblem(String id) => '$baseUrl/problems/$id/dislike';
  static String solveProblem(String id) => '$baseUrl/problems/$id/solve';

  // Contests
  static const String contests = '$baseUrl/contests';
  static String leaderboard(String id) => '$baseUrl/contests/$id/leaderboard';

  // Users
  static const String users = '$baseUrl/users';
  static String profile(String username) => '$baseUrl/users/profile/$username';
  static String heatmap(String username) =>
      '$baseUrl/users/profile/$username/analytics/heatmap';
  static String ratingHistory(String username) =>
      '$baseUrl/users/profile/$username/analytics/rating-history';
  static String attendance(String username) =>
      '$baseUrl/users/profile/$username/attendance';
  static String submissions(String username) =>
      '$baseUrl/users/profile/$username/submissions';

  // Activity
  static const String activityFeed = '$baseUrl/activity';

  // Info / Announcements
  static const String info = '$baseUrl/info';
}
