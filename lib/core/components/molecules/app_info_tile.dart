import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_text.dart';

class AppInfoTile extends StatelessWidget {
  const AppInfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),

      title: AppText(
        title,
        fontWeight: FontWeight.w600,
      ),

      subtitle: AppText(subtitle),
    );
  }
}