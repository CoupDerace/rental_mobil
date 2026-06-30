import 'package:flutter/material.dart';
import 'package:rental_mobil/core/constants/asset_constansts.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(AssetConstants.logo, width: 150),

        const SizedBox(height: 24),

        Text(
          "Selamat Datang",
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const SizedBox(height: 8),

        Text(
          "Silakan login untuk melanjutkan",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
