part of 'contests_bloc.dart';

@immutable
sealed class ContestsEvent {}

final class ContestsStarted extends ContestsEvent {}

final class ContestsFilterChanged extends ContestsEvent {
  final String filter; // e.g. All/Div1/Div2
  ContestsFilterChanged(this.filter);
}
