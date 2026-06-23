import 'package:flutter/material.dart';
import 'package:lab_portal/features/consistency/presentation/page/consistency_page.dart';
import 'package:lab_portal/features/practice/presentation/page/for_you_page.dart';
import 'package:lab_portal/features/courses/presentation/page/courses_page.dart';
import 'package:lab_portal/features/learning/presentation/page/skill_tree_page.dart';
import 'package:lab_portal/features/learning/presentation/page/tracks_page.dart';
import 'package:lab_portal/future/main/presentation/page/home_page.dart';
import 'package:lab_portal/future/main/presentation/page/problems_page.dart';
import 'package:lab_portal/future/main/presentation/page/contest_page.dart';
import 'package:lab_portal/future/main/presentation/page/users_page.dart';
import 'package:lab_portal/future/main/presentation/page/profile_page.dart';
import 'package:lab_portal/features/settings/presentation/page/settings_page.dart';
import 'package:lab_portal/features/settings/presentation/page/help_support_page.dart';
import 'package:lab_portal/future/main/presentation/page/problem_details_page.dart';
import 'package:lab_portal/future/main/presentation/page/user_details_page.dart';
import 'package:lab_portal/future/main/presentation/page/contest_leaderboard_page.dart';
import 'package:lab_portal/future/main/domain/entity/problem_entity.dart';
import 'package:lab_portal/future/main/domain/entity/user_entity.dart';
import 'package:lab_portal/future/main/domain/entity/contest_entity.dart';
import 'route_names.dart';

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
      case RouteNames.settings:
        return _page(const SettingsPage(), settings);
      case RouteNames.helpSupport:
        return _page(const HelpSupportPage(), settings);

      case RouteNames.problemDetails:
        final problem = settings.arguments as ProblemEntity;
        return _page(ProblemDetailsPage(problem: problem), settings);

      case RouteNames.userDetails:
        final user = settings.arguments as UserEntity;
        return _page(UserDetailsPage(user: user), settings);

      case RouteNames.contestLeaderboard:
        final contest = settings.arguments as ContestEntity;
        return _page(ContestLeaderboardPage(contest: contest), settings);

      // ---- phase 9: learning ----
      case RouteNames.learn:
        return _page(const SkillTreePage(), settings);
      case RouteNames.tracks:
        return _page(const TracksPage(), settings);

      // ---- phase 10: consistency ----
      case RouteNames.consistency:
        return _page(const ConsistencyPage(), settings);
      // ---- phase 11: smart practice ----
      case RouteNames.forYou:
        return _page(const ForYouPage(), settings);

      // ---- phase 15: courses ----
      case RouteNames.courses:
        return _page(const CoursesPage(), settings);

      default:
        return _page(
          const Scaffold(body: Center(child: Text('Page not found'))),
          settings,
        );
    }
  }

  static Route<dynamic> _page(Widget child, RouteSettings settings) =>
      PageRouteBuilder<dynamic>(
        settings: settings,
        pageBuilder: (_, __, ___) => child,
        transitionDuration: const Duration(milliseconds: 180),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      );
}
