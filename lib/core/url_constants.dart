import 'config/app_config.dart';

class UrlConstants {
  UrlConstants._();

  static const String _base = AppConfig.apiBaseUrl;

  // ---- auth ----
  static const String loginUrl = '$_base/auth/login/';
  static const String registerUrl = '$_base/auth/register/';
  static const String tokenRefreshUrl = '$_base/auth/token/refresh/';
  static const String logoutUrl = '$_base/auth/logout/';

  // ---- user ----
  static const String getUserInfoUrl = '$_base/user/me/';
  static const String getProfileUrl = '$_base/user/profile/';

  // ---- problems ----
  static const String getProblemsUrl = '$_base/problems/';
  static const String getDailyProblemUrl = '$_base/problems/daily/';
  static const String likeProblemUrl = '$_base/problems/like/';
  static const String dislikeProblemUrl = '$_base/problems/dislike/';
  static const String markProblemAsSolvedUrl = '$_base/problems/solve/';
  static const String unmarkProblemAsSolvedUrl = '$_base/problems/unsolve/';

  // ---- contests ----
  static const String getContestsUrl = '$_base/contests/';
  static const String getContestLeaderboardUrl = '$_base/contests/leaderboard/';

  // ---- info ----
  static const String getInfoUrl = '$_base/info/';

  // ---- users ----
  static const String getUsersUrl = '$_base/users/';
}
