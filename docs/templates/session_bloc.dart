// lib/features/auth/presentation/bloc/session/  (split into the 3 part files)
// App-level session bloc (Phase 3). Provide it ABOVE MaterialApp so the whole tree can read it.
// Remember: this repo uses Left = success for Either (see docs/00-conventions...).

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// import the auth usecases + entity once built in Phase 3:
// import '../../../domain/usecase/get_current_user.dart';
// import '../../../domain/usecase/logout.dart';
// import '../../../domain/entity/auth_user_entity.dart';

// ============================ session_event.dart ============================
abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

/// Fired on app start: check stored token, resolve user.
class SessionStarted extends SessionEvent {
  const SessionStarted();
}

/// Fired after a successful login/register.
class LoggedIn extends SessionEvent {
  final AuthUserEntity user;
  const LoggedIn(this.user);
  @override
  List<Object?> get props => [user];
}

/// Fired by logout button or on a 401.
class LoggedOut extends SessionEvent {
  const LoggedOut();
}

// ============================ session_state.dart ============================
abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

/// Splash — we don't yet know if the user is authenticated.
class SessionUnknown extends SessionState {
  const SessionUnknown();
}

class SessionAuthenticated extends SessionState {
  final AuthUserEntity user;
  const SessionAuthenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class SessionUnauthenticated extends SessionState {
  const SessionUnauthenticated();
}

// ============================ session_bloc.dart ============================
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final GetCurrentUser getCurrentUser;
  final Logout logoutUsecase;

  SessionBloc({required this.getCurrentUser, required this.logoutUsecase})
      : super(const SessionUnknown()) {
    on<SessionStarted>(_onStarted);
    on<LoggedIn>((e, emit) => emit(SessionAuthenticated(e.user)));
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onStarted(SessionStarted e, Emitter<SessionState> emit) async {
    final result = await getCurrentUser(); // reads token, calls /me
    result.fold(
      (user) => emit(SessionAuthenticated(user)),   // Left = success
      (_) => emit(const SessionUnauthenticated()),
    );
  }

  Future<void> _onLoggedOut(LoggedOut e, Emitter<SessionState> emit) async {
    await logoutUsecase();           // clears tokens
    emit(const SessionUnauthenticated());
  }
}

// NOTE: replace AuthUserEntity / GetCurrentUser / Logout with the real classes built in Phase 3.
