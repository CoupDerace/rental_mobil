import 'package:flutter/material.dart';

class AppNoConnection extends StatelessWidget {
  final VoidCallback? onRetry;

  const AppNoConnection({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 80),
            const SizedBox(height: 20),
            Text(
              'Tidak Ada Koneksi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Periksa koneksi internet kemudian coba kembali.',
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onRetry, child: const Text('Muat Ulang')),
            ],
          ],
        ),
      ),
    );
  }
}
