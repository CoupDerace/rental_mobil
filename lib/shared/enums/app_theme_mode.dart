import 'package:flutter/material.dart';

enum AppThemeMode { system, light, dark }

extension AppThemeModeExtension on AppThemeMode {
  ThemeMode get themeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;

      case AppThemeMode.dark:
        return ThemeMode.dark;

      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  String get title {
    switch (this) {
      case AppThemeMode.system:
        return 'System';

      case AppThemeMode.light:
        return 'Light';

      case AppThemeMode.dark:
        return 'Dark';
    }
  }
}
