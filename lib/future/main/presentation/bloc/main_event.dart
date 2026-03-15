part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

class ChangePageEvent extends MainEvent {
  final int pageIndex;

  ChangePageEvent(this.pageIndex);
}

class SearchEvent extends MainEvent {
  final String query;

  SearchEvent(this.query);
}

class RefreshEvent extends MainEvent {}

class LoadMoreEvent extends MainEvent {}

class LoadProblemsEvent extends MainEvent {}

class LoadContestsEvent extends MainEvent {}

class LoadUsersEvent extends MainEvent {}

class LoadUserDetailsEvent extends MainEvent {
  final String username;

  LoadUserDetailsEvent(this.username);
}

class LoadUserProfileEvent extends MainEvent {
  final String username;

  LoadUserProfileEvent(this.username);
}

class LoadDailyProblemsEvent extends MainEvent {}

class LikeProblemEvent extends MainEvent {
  final String problemId;

  LikeProblemEvent(this.problemId);
}
