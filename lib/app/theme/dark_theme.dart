import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData darkThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.orange, // Utama Orange
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkOnSurface,
  ),
  cardTheme: const CardTheme(
    color: AppColors.darkSurface,
    elevation: 0,
  ),
);