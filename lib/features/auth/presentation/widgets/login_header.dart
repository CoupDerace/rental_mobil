import 'package:flutter/material.dart';

import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/widgets/app_logo_text.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppLogo(size: 120),

        SizedBox(height: 20),

        AppLogoText(),

        SizedBox(height: 8),

        Text("Silakan login untuk melanjutkan"),
      ],
    );
  }
}
