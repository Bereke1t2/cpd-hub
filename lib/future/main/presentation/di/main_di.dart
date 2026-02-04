import 'package:flutter/material.dart';

import 'package:lab_portal/core/network.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contests_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_daily_problem_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_problems_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_users_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/mock/mock_contest_leaderboard_data_source.dart';
import 'package:lab_portal/future/main/data/dataSources/remote/remote_data_source.dart';
import 'package:lab_portal/future/main/data/repository/main_repo.dart';
import 'package:lab_portal/future/main/domain/repository/main_repo.dart';
import 'package:lab_portal/future/main/domain/usecase/get_contests.dart';
import 'package:lab_portal/future/main/domain/usecase/get_daily_problm.dart';
import 'package:lab_portal/future/main/domain/usecase/get_problems.dart';
import 'package:lab_portal/future/main/domain/usecase/get_users.dart';
import 'package:lab_portal/future/main/domain/usecase/get_contest_leaderboard.dart';
import 'package:lab_portal/future/main/presentation/bloc/contests/contests_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/daily_problem/daily_problem_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/problems/problems_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/users/users_bloc.dart';
import 'package:lab_portal/future/main/presentation/bloc/contest_leaderboard/contest_leaderboard_bloc.dart';

class MainDI {
  static MainRepo buildRepo() {
    // TODO: swap RemoteDataSourceImpl with a real HTTP implementation.
    final remote = RemoteDataSourceImpl();
    final network = NetworkInfoImpl();

    final mockUsers = MockUsersDataSourceImpl();
    final mockProblems = MockProblemsDataSourceImpl();
    final mockContests = MockContestsDataSourceImpl();
    final mockDaily = MockDailyProblemDataSourceImpl();
    final mockLeaderboard = MockContestLeaderboardDataSourceImpl();

    return MainRepoImpl(
      remote,
      network,
      mockUsers,
      mockProblems,
      mockContests,
      mockDaily,
      mockLeaderboard,
    );
  }

  static UsersBloc buildUsersBloc() {
    return UsersBloc(getUsers: GetUsers(buildRepo()));
  }

  static ProblemsBloc buildProblemsBloc() {
    return ProblemsBloc(getProblems: GetProblems(buildRepo()));
  }

  static ContestsBloc buildContestsBloc() {
    return ContestsBloc(getContests: GetContests(buildRepo()));
  }

  static DailyProblemBloc buildDailyProblemBloc() {
    return DailyProblemBloc(getDailyProblems: GetDailyProblems(buildRepo()));
  }

  static ContestLeaderboardBloc buildContestLeaderboardBloc() {
    return ContestLeaderboardBloc(
      getContestLeaderboard: GetContestLeaderboard(buildRepo()),
    );
  }

  static Widget provideUsersBloc({required Widget child}) {
    // Simple constructor-based DI without extra packages.
    // If you later add get_it, this can move there.
    return child;
  }
}
