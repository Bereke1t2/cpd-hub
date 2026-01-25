part of 'contests_bloc.dart';

@immutable
sealed class ContestsState {
  const ContestsState();
}

final class ContestsInitial extends ContestsState {
  const ContestsInitial();
}

final class ContestsLoading extends ContestsState {
  const ContestsLoading();
}

final class ContestsLoaded extends ContestsState {
  final List<ContestEntitiy> contests;
  final String filter;

  const ContestsLoaded({required this.contests, this.filter = 'All'});
}

final class ContestsError extends ContestsState {
  final String message;
  const ContestsError(this.message);
}
