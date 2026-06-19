import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lab_portal/features/auth/domain/entity/auth_user_entity.dart';
import 'package:lab_portal/features/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:lab_portal/features/auth/domain/usecase/logout_usecase.dart';

part 'session_event.dart';
part 'session_state.dart';

class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final GetCurrentUser getCurrentUser;
  final Logout logout;

  SessionBloc({required this.getCurrentUser, required this.logout})
      : super(const SessionUnknown()) {
    on<SessionStarted>(_onStarted);
    on<SessionLoggedIn>((e, emit) => emit(SessionAuthenticated(e.user)));
    on<SessionLoggedOut>(_onLoggedOut);
  }

  Future<void> _onStarted(
    SessionStarted event,
    Emitter<SessionState> emit,
  ) async {
    final result = await getCurrentUser();
    result.fold(
      (user) => emit(SessionAuthenticated(user)),     // Left = success
      (_) => emit(const SessionUnauthenticated()),
    );
  }

  Future<void> _onLoggedOut(
    SessionLoggedOut event,
    Emitter<SessionState> emit,
  ) async {
    await logout();
    emit(const SessionUnauthenticated());
  }
}
