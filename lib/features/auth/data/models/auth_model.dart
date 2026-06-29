import 'package:rental_mobil/features/auth/domain/entities/auth.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required super.id,
    required super.authUserId,
    required super.nama,
    required super.email,
    required super.role,
    required super.noHp,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'].toString(),
      authUserId: json['auth_user_id'].toString(),
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      noHp: json['no_hp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'nama': nama,
      'email': email,
      'role': role,
      'no_hp': noHp,
    };
  }
}