class RoleConstants {
  RoleConstants._();

  static const String admin = 'admin';
  static const String owner = 'owner';
  static const String operator = 'operator';

  static const List<String> all = [
    admin,
    owner,
    operator,
  ];

  static bool isValid(String role) {
    return all.contains(role);
  }
}