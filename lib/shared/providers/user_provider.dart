import 'package:flutter/material.dart';

import '../../shared/enums/app_role.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';

  AppRole _role = AppRole.operator;

  String get name => _name;

  AppRole get role => _role;

  bool get isAdmin => _role == AppRole.admin;

  bool get isOwner => _role == AppRole.owner;

  bool get isOperator => _role == AppRole.operator;

  void update({required String name, required AppRole role}) {
    _name = name;
    _role = role;

    notifyListeners();
  }

  void clear() {
    _name = '';
    _role = AppRole.operator;

    notifyListeners();
  }
}
