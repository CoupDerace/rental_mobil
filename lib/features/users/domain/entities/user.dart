class User {
  final String id;
  final String? authUserId;
  final String nama;
  final String email;
  final String role;
  final String? noHp;
  final DateTime? createdAt;

  const User({
    required this.id,
    this.authUserId,
    required this.nama,
    required this.email,
    required this.role,
    this.noHp,
    this.createdAt,
  });
}
