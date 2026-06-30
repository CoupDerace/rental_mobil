import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/app/routes/routes.dart';
import 'package:rental_mobil/features/auth/domain/usecases/login_usecase.dart';
import 'package:rental_mobil/shared/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginProvider({required this.loginUseCase});

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
    if (!formKey.currentState!.validate()) return;

    try {
      _loading = true;
      notifyListeners();

      await loginUseCase(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!context.mounted) return;
      final auth = context.read<AuthProvider>();

      await auth.loadSession();

      _loading = false;
      notifyListeners();

      if (!context.mounted) return;

      final role = auth.role.toLowerCase();
      String dashboardRoute;
      if (role == 'admin') {
        dashboardRoute = AppRoutes.dashboard;
      } else if (role == 'owner') {
        dashboardRoute = AppRoutes.ownerDashboard;
      } else {
        dashboardRoute = AppRoutes.operatorDashboard;
      }

      Navigator.pushReplacementNamed(context, dashboardRoute);
    } on AuthException catch (e) {
      _loading = false;
      notifyListeners();

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      _loading = false;
      notifyListeners();

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
