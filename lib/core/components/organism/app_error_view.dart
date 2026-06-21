import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 60),

          const SizedBox(height: 12),

          Text(message),

          const SizedBox(height: 16),

          if (onRetry != null)
            FilledButton(onPressed: onRetry, child: const Text("Coba Lagi")),
        ],
      ),
    );
  }
}
