import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_text.dart';

class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle({
    super.key,
    required this.title,
    this.action,
  });

  final String title;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Expanded(
          child: AppText(
            title,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (action != null) action!,
      ],
    );
  }
}