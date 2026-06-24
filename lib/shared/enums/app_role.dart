enum AppRole { admin, owner, operator }

extension AppRoleExtension on AppRole {
  String get name {
    switch (this) {
      case AppRole.admin:
        return 'Admin';
      case AppRole.owner:
        return 'Owner';
      case AppRole.operator:
        return 'Operator';
    }
  }

  String get value {
    switch (this) {
      case AppRole.admin:
        return 'admin';
      case AppRole.owner:
        return 'owner';
      case AppRole.operator:
        return 'operator';
    }
  }
}
