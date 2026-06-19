part of 'session_bloc.dart';

abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object?> get props => [];
}

/// Initial — checking stored token. Show a splash/loading screen.
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
