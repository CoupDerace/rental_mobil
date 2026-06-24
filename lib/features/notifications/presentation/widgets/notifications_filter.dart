import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notifications_provider.dart';

class NotificationFilter extends StatelessWidget {
  const NotificationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<NotificationsProvider>().markAllAsRead();
        },
        icon: const Icon(Icons.done_all),
        label: const Text("Tandai Semua"),
      ),
    );
  }
}
