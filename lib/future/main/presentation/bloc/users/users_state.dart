part of 'users_bloc.dart';

@immutable
sealed class UsersState {
  const UsersState();
}

final class UsersInitial extends UsersState {
  const UsersInitial();
}

final class UsersLoading extends UsersState {
  const UsersLoading();
}

final class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final String query;

  const UsersLoaded({required this.users, this.query = ''});
}

final class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
}
