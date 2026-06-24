import 'package:flutter/material.dart';
import 'package:rental_mobil/app/routes/routes.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _rememberMe = false;

  bool get loading => _loading;
  bool get rememberMe => _rememberMe;

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    _loading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _loading = false;
    notifyListeners();

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
