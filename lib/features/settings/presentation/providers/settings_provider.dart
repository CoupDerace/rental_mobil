import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _language = 'Indonesia';
  bool _biometric = false;

  ThemeMode get themeMode => _themeMode;
  String get language => _language;
  bool get biometric => _biometric;

  void changeTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void changeLanguage(String language) {
    _language = language;
    notifyListeners();
  }

  void enableBiometric(bool value) {
    _biometric = value;
    notifyListeners();
  }
}
