import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notifications_provider.dart';
import 'notifications_card.dart';

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationsProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.notifications.length,
      itemBuilder: (_, index) {
        return GestureDetector(
          onTap: () {
            provider.markAsRead(index);
          },
          child: NotificationCard(notification: provider.notifications[index]),
        );
      },
    );
  }
}
