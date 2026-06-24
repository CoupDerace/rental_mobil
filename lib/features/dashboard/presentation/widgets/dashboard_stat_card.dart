import 'package:flutter/material.dart';

class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon),

            const Spacer(),

            Text(value, style: Theme.of(context).textTheme.headlineMedium),

            const SizedBox(height: 8),

            Text(title),
          ],
        ),
      ),
    );
  }
}
