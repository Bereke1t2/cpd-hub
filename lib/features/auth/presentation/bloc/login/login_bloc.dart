import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_portal/features/auth/domain/entity/auth_user_entity.dart';
import 'package:lab_portal/features/auth/domain/usecase/login_usecase.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final Login login;

  LoginBloc({required this.login}) : super(const LoginInitial()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());
    final result = await login(event.email, event.password);
    result.fold(
      (user) => emit(LoginSuccess(user)),
      (failure) => emit(LoginFailure(failure.message)),
    );
  }
}
