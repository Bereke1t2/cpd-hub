import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/core/injection.dart';
import 'package:cpd_hub/future/main/presentation/bloc/contest_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/home_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/leaderboard_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/problems_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/profile_cubit.dart';
import 'package:cpd_hub/future/main/presentation/bloc/users_cubit.dart';
import 'package:cpd_hub/future/main/presentation/page/home_page.dart';
import 'package:cpd_hub/future/main/presentation/page/problems_page.dart';
import 'package:cpd_hub/future/main/presentation/page/contest_page.dart';
import 'package:cpd_hub/future/main/presentation/page/profile_page.dart';
import 'package:cpd_hub/future/main/presentation/page/users_page.dart';
import 'package:cpd_hub/future/auth/presentation/page/login_page.dart';
import 'package:cpd_hub/future/auth/presentation/page/signup_page.dart';
import 'package:cpd_hub/core/contest_reminder_service.dart';
import 'package:cpd_hub/core/theme/app_theme.dart';
import 'package:cpd_hub/core/theme/theme_cubit.dart';
import 'package:cpd_hub/future/learning/presentation/bloc/roadmap_cubit.dart';
import 'package:cpd_hub/future/learning/presentation/pages/learning_hub_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ContestReminderService.instance.init();

  final injection = Injection();
  injection.init();

  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: MyApp(injection: injection),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Injection injection;

  const MyApp({super.key, required this.injection});

  static const _tabRoutes = {'/', '/problems', '/contests', '/users', '/profile'};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, AppTheme>(
      builder: (context, themeState) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomeCubit>.value(value: injection.homeCubit),
            BlocProvider<ProblemsCubit>.value(value: injection.problemsCubit),
            BlocProvider<ContestCubit>.value(value: injection.contestCubit),
            BlocProvider<LeaderboardCubit>.value(
              value: injection.leaderboardCubit,
            ),
            BlocProvider<UsersCubit>.value(value: injection.usersCubit),
            BlocProvider<ProfileCubit>.value(value: injection.profileCubit),
            BlocProvider<RoadmapCubit>.value(value: injection.roadmapCubit),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CPD Hub',
            theme: themeState.themeData,
            initialRoute: '/login',
            onGenerateRoute: (settings) {
              final page = _buildPage(settings.name);
              if (page == null) return null;

              if (_tabRoutes.contains(settings.name)) {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => page,
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              }

              return MaterialPageRoute(
                settings: settings,
                builder: (_) => page,
              );
            },
          ),
        );
      },
    );
  }

  Widget? _buildPage(String? name) {
    switch (name) {
      case '/login':
        return const LoginPage();
      case '/signup':
        return const SignupPage();
      case '/':
        return HomePage();
      case '/problems':
        return ProblemsPage();
      case '/contests':
        return ContestPage();
      case '/profile':
        return const ProfilePage();
      case '/users':
        return UsersPage();
      case '/learning':
        return const LearningHubPage();
      default:
        return null;
    }
  }
}
