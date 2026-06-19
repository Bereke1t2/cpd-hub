// lib/core/routing/route_names.dart  +  lib/core/routing/app_router.dart
// Central routing (Phase 1). Tabs keep simple names; detail screens take typed arguments.

// ============================ route_names.dart ============================
class RouteNames {
  RouteNames._();
  static const String home = '/';
  static const String problems = '/problems';
  static const String contests = '/contests';
  static const String users = '/users';
  static const String profile = '/profile';

  // detail screens (take arguments)
  static const String problemDetails = '/problem';
  static const String userDetails = '/user';
  static const String contestLeaderboard = '/contest-leaderboard';

  // auth (Phase 3)
  static const String login = '/login';
  static const String register = '/register';
  static const String settings = '/settings';
}

// ============================ app_router.dart ============================
import 'package:flutter/material.dart';
import 'package:lab_portal/future/main/presentation/page/home_page.dart';
import 'package:lab_portal/future/main/presentation/page/problems_page.dart';
import 'package:lab_portal/future/main/presentation/page/contest_page.dart';
import 'package:lab_portal/future/main/presentation/page/users_page.dart';
import 'package:lab_portal/future/main/presentation/page/profile_page.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import 'package:lab_portal/future/main/presentation/page/user_details_page.dart';
import 'package:lab_portal/future/main/presentation/page/contest_leaderboard_page.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.home:
        return _page(const HomePage(), settings);
      case RouteNames.problems:
        return _page(const ProblemsPage(), settings);
      case RouteNames.contests:
        return _page(const ContestPage(), settings);
      case RouteNames.users:
        return _page(const UsersPage(), settings);
      case RouteNames.profile:
        return _page(const ProfilePage(), settings);

      case RouteNames.problemDetails:
        final problem = settings.arguments as ProblemEntity;
        return _page(ProblemDetailsPage(problem: problem), settings);

      case RouteNames.userDetails:
        final user = settings.arguments as UserEntity;
        return _page(UserDetailsPage(user: user), settings);

      case RouteNames.contestLeaderboard:
        final contest = settings.arguments as ContestEntity;
        return _page(ContestLeaderboardPage(contest: contest), settings);

      default:
        return _page(
          Scaffold(body: Center(child: Text('No route for ${settings.name}'))),
          settings,
        );
    }
  }

  static MaterialPageRoute _page(Widget child, RouteSettings settings) =>
      MaterialPageRoute(builder: (_) => child, settings: settings);
}

// Navigation helpers:
//   Navigator.pushNamed(context, RouteNames.userDetails, arguments: user);
//   Navigator.pushNamed(context, RouteNames.problemDetails, arguments: problem);
