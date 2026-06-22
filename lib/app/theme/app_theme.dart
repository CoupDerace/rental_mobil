import 'package:flutter/material.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => DarkTheme.theme;

  static ThemeData get light => LightTheme.theme;
}
