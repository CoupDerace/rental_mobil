import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/atoms/app_button.dart';
import '../../../../core/components/atoms/app_checkbox.dart';
import '../../../../core/components/atoms/app_password_field.dart';
import '../../../../core/components/atoms/app_textfield.dart';
import '../../../../core/utils/input_validator.dart';
import '../providers/login_provider.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Form(
      key: provider.formKey,
      child: Column(
        children: [
          AppTextField(
            controller: provider.emailController,
            label: "Email",
            validator: InputValidator.email,
          ),

          const SizedBox(height: 20),

          AppPasswordField(
            controller: provider.passwordController,
            hint: "Password",
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              AppCheckbox(
                value: provider.rememberMe,
                onChanged: (value) {
                  provider.setRememberMe(value ?? false);
                },
              ),

              const Text("Remember me"),

              const Spacer(),

              TextButton(onPressed: () {}, child: const Text("Lupa Password?")),
            ],
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: "Login",
              loading: provider.loading,
              onPressed: () {
                provider.login(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
