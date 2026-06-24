import 'package:flutter/material.dart';

class AppComingSoon extends StatelessWidget {
  final String feature;

  const AppComingSoon({super.key, this.feature = 'Fitur'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 80),
            const SizedBox(height: 20),
            Text(
              '$feature Segera Hadir',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Fitur ini sedang dalam proses pengembangan.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
