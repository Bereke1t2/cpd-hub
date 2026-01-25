part of 'users_bloc.dart';

@immutable
sealed class UsersEvent {}

final class UsersStarted extends UsersEvent {}

final class UsersSearchChanged extends UsersEvent {
  final String query;
  UsersSearchChanged(this.query);
}
