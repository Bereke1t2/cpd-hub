import 'package:lab_portal/features/auth/domain/entity/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.fullName,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: (json['id'] ?? json['pk'] ?? '').toString(),
        username: (json['username'] ?? '') as String,
        email: (json['email'] ?? '') as String,
        fullName: (json['full_name'] ?? json['fullName'] ?? '') as String,
      );
}
