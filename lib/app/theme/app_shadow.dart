import 'package:flutter/material.dart';

class AppShadow {
  AppShadow._();

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> medium = [
    BoxShadow(
      color: Colors.black.withValues(alpha: .15),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];
}
