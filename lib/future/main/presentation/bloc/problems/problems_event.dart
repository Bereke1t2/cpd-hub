part of 'problems_bloc.dart';

@immutable
sealed class ProblemsEvent {}

final class ProblemsStarted extends ProblemsEvent {}

final class ProblemsSearchChanged extends ProblemsEvent {
  final String query;
  ProblemsSearchChanged(this.query);
}
