import '../../domain/entities/user.dart';

class AuthModel extends User {
  const AuthModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    // Use 'data' for sign up, fallback to top-level for login if needed
    return AuthModel(
      id: data['id']?.toString() ?? json['id']?.toString() ?? '',
      name: data['name'] ?? json['name'] ?? '',
      email: data['email'] ?? json['email'] ?? '',
      token: data['token'] ??
          data['access_token'] ??
          json['token'] ??
          json['access_token'] ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'email': email, 'token': token};
  }
}
