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
import 'package:cpd_hub/future/auth/presentation/page/splash_page.dart';
import 'package:cpd_hub/future/auth/presentation/page/login_page.dart';
import 'package:cpd_hub/future/auth/presentation/page/signup_page.dart';

void main() {
  final injection = Injection();
  injection.init();

  runApp(MyApp(injection: injection));
}

class MyApp extends StatelessWidget {
  final Injection injection;

  const MyApp({super.key, required this.injection});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>.value(value: injection.homeCubit),
        BlocProvider<ProblemsCubit>.value(value: injection.problemsCubit),
        BlocProvider<ContestCubit>.value(value: injection.contestCubit),
        BlocProvider<LeaderboardCubit>.value(value: injection.leaderboardCubit),
        BlocProvider<UsersCubit>.value(value: injection.usersCubit),
        BlocProvider<ProfileCubit>.value(value: injection.profileCubit),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CPD Hub',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashPage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignupPage(),
          '/': (context) => const HomePage(),
          '/problems': (context) => const ProblemsPage(),
          '/contests': (context) => const ContestPage(),
          '/profile': (context) => const ProfilePage(),
          '/users': (context) => const UsersPage(),
        },
      ),
    );
  }
}