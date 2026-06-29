import 'package:flutter/material.dart';

import '../../../../core/components/atoms/app_password_field.dart';
import '../../../../core/components/organism/app_scaffold.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Ubah Password",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            AppPasswordField(hint: "Password Lama"),

            SizedBox(height: 16),

            AppPasswordField(hint: "Password Baru"),

            SizedBox(height: 16),

            AppPasswordField(hint: "Konfirmasi Password"),
          ],
        ),
      ),
    );
  }
}
