part of 'session_bloc.dart';

abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

/// Fired once in main() — checks stored token, resolves initial auth state.
class SessionStarted extends SessionEvent {
  const SessionStarted();
}

/// Fired after a successful login or register.
class SessionLoggedIn extends SessionEvent {
  final AuthUserEntity user;
  const SessionLoggedIn(this.user);
  @override
  List<Object?> get props => [user];
}

/// Fired by the logout button or when a 401 is received mid-session.
class SessionLoggedOut extends SessionEvent {
  const SessionLoggedOut();
}
