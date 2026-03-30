part of 'users_cubit.dart';

abstract class UsersState extends Equatable {
  const UsersState();
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserEntity> users;
  final bool hasMore;
  final bool isLoadingMore;

  const UsersLoaded(
    this.users, {
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  UsersLoaded copyWith({
    List<UserEntity>? users,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return UsersLoaded(
      users ?? this.users,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [users, hasMore, isLoadingMore];
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
  @override
  List<Object?> get props => [message];
}
