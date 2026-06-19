class AuthTokenModel {
  final String access;
  final String? refresh;

  const AuthTokenModel({required this.access, this.refresh});

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => AuthTokenModel(
        access: (json['access'] ?? json['access_token'] ?? '') as String,
        refresh: (json['refresh'] ?? json['refresh_token']) as String?,
      );
}
