import 'package:flutter/material.dart';

class AppUnauthorizedState extends StatelessWidget {
  const AppUnauthorizedState({super.key, this.onLogin});

  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80),

            const SizedBox(height: 20),

            Text(
              "Akses Ditolak",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 8),

            const Text(
              "Silakan login untuk melanjutkan.",
              textAlign: TextAlign.center,
            ),

            if (onLogin != null) ...[
              const SizedBox(height: 24),

              FilledButton(onPressed: onLogin, child: const Text("Login")),
            ],
          ],
        ),
      ),
    );
  }
}
