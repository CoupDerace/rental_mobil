import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _authenticated = false;

  bool get isAuthenticated => _authenticated;

  void login() {
    _authenticated = true;
    notifyListeners();
  }

  void logout() {
    _authenticated = false;
    notifyListeners();
  }
}
  