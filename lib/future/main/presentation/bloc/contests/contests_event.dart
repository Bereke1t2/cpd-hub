part of 'contests_bloc.dart';

@immutable
sealed class ContestsEvent {}

final class ContestsStarted extends ContestsEvent {}

/// Platform filter: 'All' or a platform name ('Codeforces', 'LeetCode', …).
final class ContestsFilterChanged extends ContestsEvent {
  final String filter;
  ContestsFilterChanged(this.filter);
}
