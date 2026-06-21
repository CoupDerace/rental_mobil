import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color orange = Color(0xFFFF5722); // Utama di Dark Mode
  static const Color blue = Color(0xFF2196F3);   // Utama di Light Mode (Pengganti Orange)

  // Dark Theme (Base Hitam)
  static const Color darkBackground = Color(0xFF0F172A); // Hitam kebiruan tua
  static const Color darkSurface = Color(0xFF1E293B);    // Warna card/sidebar
  static const Color darkOnSurface = Color(0xFFF8FAFC);  // Teks putih/terang

  // Light Theme (Base Putih)
  static const Color lightBackground = Color(0xFFF8FAFC); // Putih abu terang
  static const Color lightSurface = Colors.white;         // Warna card putih bersih
  static const Color lightOnSurface = Color(0xFF0F172A);  // Teks hitam/gelap
}