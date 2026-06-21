import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,
  colorScheme: const ColorScheme.light(
    primary: AppColors.blue, // Utama Biru (pengganti orange)
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightOnSurface,
  ),
  cardTheme: const CardTheme(
    color: AppColors.lightSurface,
    elevation: 0,
  ),
);