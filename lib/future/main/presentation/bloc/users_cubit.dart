import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_users.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsers getUsers;

  static const int _pageSize = 20;
  int _currentPage = 1;

  UsersCubit({required this.getUsers}) : super(UsersInitial());

  Future<void> loadUsers() async {
    _currentPage = 1;
    emit(UsersLoading());
    final result = await getUsers(page: 1, limit: _pageSize);
    result.fold(
      (users) => emit(UsersLoaded(
        users,
        hasMore: users.length >= _pageSize,
      )),
      (failure) => emit(UsersError(failure.message)),
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! UsersLoaded || !currentState.hasMore || currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));
    _currentPage++;

    final result = await getUsers(page: _currentPage, limit: _pageSize);
    result.fold(
      (newUsers) {
        final all = [...currentState.users, ...newUsers];
        emit(UsersLoaded(
          all,
          hasMore: newUsers.length >= _pageSize,
        ));
      },
      (failure) {
        _currentPage--;
        emit(currentState.copyWith(isLoadingMore: false));
      },
    );
  }
}
