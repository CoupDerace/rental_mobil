class AuthEntity {
  final String id;
  final String authUserId;
  final String nama;
  final String email;
  final String role;
  final String noHp;

  const AuthEntity({
    required this.id,
    required this.authUserId,
    required this.nama,
    required this.email,
    required this.role,
    required this.noHp,
  });
}