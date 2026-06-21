import 'package:flutter/material.dart';

class AppShadow {
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];
}