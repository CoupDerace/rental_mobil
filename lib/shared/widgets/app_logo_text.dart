import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_text.dart';

class AppLogoText extends StatelessWidget {
  const AppLogoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AppText(
      "Rental Mobil",
      fontSize: 28,
      fontWeight: FontWeight.bold,
    );
  }
}