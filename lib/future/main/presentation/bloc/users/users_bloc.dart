import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entitiy/user_entity.dart';
import '../../../domain/usecase/get_users.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;

  List<UserEntity> _allUsers = const [];

  UsersBloc({required this.getUsers}) : super(const UsersInitial()) {
    on<UsersStarted>(_onStarted);
    on<UsersSearchChanged>(_onSearchChanged);
  }

  Future<void> _onStarted(UsersStarted event, Emitter<UsersState> emit) async {
    emit(const UsersLoading());
    final result = await getUsers();
    result.fold(
      (users) {
        _allUsers = users;
        emit(UsersLoaded(users: users));
      },
      (failure) => emit(UsersError(failure.message)),
    );
  }

  void _onSearchChanged(
    UsersSearchChanged event,
    Emitter<UsersState> emit,
  ) {
    final query = event.query.trim().toLowerCase();
    final filtered = query.isEmpty
        ? _allUsers
        : _allUsers
            .where((u) =>
                u.username.toLowerCase().contains(query) ||
                u.fullName.toLowerCase().contains(query))
            .toList();

    emit(UsersLoaded(users: filtered, query: event.query));
  }
}
