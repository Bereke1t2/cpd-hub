part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}


final class HomePageState extends MainState {

}

final class UserProfileState extends MainState {

}
final class UsersPageState extends MainState {
}

final class ContestsPageState extends MainState {
}

final class ProblemsPageState extends MainState {
}



final class LoadingState extends MainState {}
final class ErrorState extends MainState {
  final String message;

  ErrorState(this.message);
}

final class ProblemsLoadedState extends ProblemsPageState {
  final List problems;
  final bool hasReachedMax;

  ProblemsLoadedState(this.problems, {this.hasReachedMax = false});
}
final class ContestsLoadedState extends ContestsPageState {
  final List contests;
  final bool hasReachedMax;

  ContestsLoadedState(this.contests, {this.hasReachedMax = false});
}
final class UsersLoadedState extends UsersPageState {
  final List users;
  final bool hasReachedMax; 
  UsersLoadedState(this.users, {this.hasReachedMax = false});
}
final class UserDetailsLoadedState extends UserProfileState {
  final Map<String, dynamic> userDetails;

  UserDetailsLoadedState(this.userDetails);
}
final class UserProfileLoadedState extends UserProfileState {
  final Map<String, dynamic> userProfile;
  UserProfileLoadedState(this.userProfile);
}
final class PageChangedState extends MainState {
  final int pageIndex;

  PageChangedState(this.pageIndex);
}
final class SearchState extends MainState {
  final String query;

  SearchState(this.query);
}
final class RefreshedState extends MainState {}
final class MoreLoadedState extends MainState {}
final class ProblemsMoreLoadedState extends ProblemsPageState {
  final List problems;
  final bool hasReachedMax;

  ProblemsMoreLoadedState(this.problems, {this.hasReachedMax = false});
}
final class ContestsMoreLoadedState extends ContestsPageState {
  final List contests;
  final bool hasReachedMax;

  ContestsMoreLoadedState(this.contests, {this.hasReachedMax = false});
}
final class UsersMoreLoadedState extends UsersPageState {
  final List users;
  final bool hasReachedMax; 
  UsersMoreLoadedState(this.users, {this.hasReachedMax = false});
}

final class DailyProblemsLoadedState extends ProblemsPageState {
  final List dailyProblems;

  DailyProblemsLoadedState({required this.dailyProblems});
}