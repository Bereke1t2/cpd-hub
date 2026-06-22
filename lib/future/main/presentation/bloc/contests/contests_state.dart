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
  /// All contests (unfiltered) — used to derive the platform chip list.
  final List<ContestEntity> all;

  /// Active platform filter; 'All' means no filter.
  final String platform;

  const ContestsLoaded({required this.all, this.platform = 'All'});

  /// Filtered view used by the UI.
  List<ContestEntity> get contests => platform == 'All'
      ? all
      : all.where((c) => c.platform == platform).toList();

  /// Distinct platforms from the full list, sorted alphabetically.
  List<String> get platforms =>
      ({'All', ...all.map((c) => c.platform)}).toList()..sort();
}

final class ContestsError extends ContestsState {
  final String message;
  const ContestsError(this.message);
}
