import 'package:rental_mobil/features/auth/domain/entities/auth.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.id,

    required super.email,

    required super.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(id: json["id"], email: json["email"], role: json["role"]);
  }
}
