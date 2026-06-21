import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    this.title = 'Data Kosong',
    this.subtitle = 'Belum ada data yang tersedia.',
    this.icon = Icons.inbox_outlined,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80),

            const SizedBox(height: 20),

            Text(title, style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 8),

            Text(subtitle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
