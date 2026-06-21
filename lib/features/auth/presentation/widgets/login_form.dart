import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_button.dart';
import 'package:rental_mobil/core/components/atoms/app_password_field.dart';
import 'package:rental_mobil/core/components/atoms/app_textfield.dart';
import 'package:rental_mobil/features/auth/presentation/providers/auth_state.dart';

import '../../../../core/utils/input_validator.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          controller: emailController,
          label: "Email",
          keyboardType: TextInputType.emailAddress,
          validator: InputValidator.email,
        ),

        const SizedBox(height: 20),

        AppPasswordField(
          controller: passwordController,
          validator: InputValidator.password,
        ),

        const SizedBox(height: 30),

        AppButton(
          text: "Login",

          icon: Icons.login,

          isLoading: state.status == AuthStatus.loading,

          onPressed: onLogin,
        ),
      ],
    );
  }
}
