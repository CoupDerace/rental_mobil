import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rental_mobil/app/routes/routes.dart';

class SplashProvider extends ChangeNotifier {
  Future<void> initialize(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
