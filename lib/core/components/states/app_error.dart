import 'package:flutter/material.dart';

class AppError extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback? onRetry;

  const AppError({
    super.key,
    this.title = 'Terjadi Kesalahan',
    this.description,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 72, color: Colors.red),
            const SizedBox(height: 20),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description!, textAlign: TextAlign.center),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton(onPressed: onRetry, child: const Text('Coba Lagi')),
            ],
          ],
        ),
      ),
    );
  }
}
