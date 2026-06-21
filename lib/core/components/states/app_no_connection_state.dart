import 'package:flutter/material.dart';

class AppNoConnectionState extends StatelessWidget {
  const AppNoConnectionState({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80),

            const SizedBox(height: 20),

            Text(
              "Tidak ada koneksi internet",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            const Text(
              "Periksa koneksi internet kemudian coba lagi.",
              textAlign: TextAlign.center,
            ),

            if (onRetry != null) ...[
              const SizedBox(height: 24),

              FilledButton(onPressed: onRetry, child: const Text("Muat Ulang")),
            ],
          ],
        ),
      ),
    );
  }
}
