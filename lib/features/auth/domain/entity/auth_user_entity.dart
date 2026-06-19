import 'package:equatable/equatable.dart';

class AuthUserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String fullName;

  const AuthUserEntity({
    required this.id,
    required this.username,
    required this.email,
    required this.fullName,
  });

  @override
  List<Object?> get props => [id, username, email, fullName];
}
