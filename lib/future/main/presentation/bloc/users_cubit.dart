import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpd_hub/future/main/domain/entitiy/user_entity.dart';
import 'package:cpd_hub/future/main/domain/usecase/get_users.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final GetUsers getUsers;

  UsersCubit({required this.getUsers}) : super(UsersInitial());

  Future<void> loadUsers() async {
    emit(UsersLoading());
    final result = await getUsers();
    result.fold(
      (users) => emit(UsersLoaded(users)),
      (failure) => emit(UsersError(failure.message)),
    );
  }
}
