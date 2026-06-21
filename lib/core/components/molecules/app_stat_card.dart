import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_text.dart';

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 36),

            const SizedBox(height: 12),

            AppText(value, fontSize: 22, fontWeight: FontWeight.bold),

            AppText(title),
          ],
        ),
      ),
    );
  }
}
