import 'package:rental_mobil/features/auth/presentation/providers/auth_state.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  void emailChanged(String value) {
    state = state.copyWith(email: value);
  }

  void passwordChanged(String value) {
    state = state.copyWith(password: value);
  }

  void toggleRemember() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void togglePassword() {
    state = state.copyWith(obscurePassword: !state.obscurePassword);
  }

  Future<void> login() async {
    state = state.copyWith(status: AuthStatus.loading);

    await Future.delayed(const Duration(seconds: 2));

    state = state.copyWith(status: AuthStatus.authenticated);
  }

  void logout() {
    state = const AuthState();
  }
}
