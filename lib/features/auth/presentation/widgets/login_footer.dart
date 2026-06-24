import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),

        Text(
          "© 2026 Rental Mobil",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
