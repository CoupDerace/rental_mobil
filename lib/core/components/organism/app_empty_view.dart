import 'package:flutter/material.dart';

class AppEmptyView extends StatelessWidget {
  const AppEmptyView({
    super.key,
    this.message = 'Belum ada data',
    this.icon = Icons.inbox,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60),

          const SizedBox(height: 12),

          Text(message),
        ],
      ),
    );
  }
}
