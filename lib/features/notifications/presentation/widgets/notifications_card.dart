import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Icon(
            notification["isRead"]
                ? Icons.notifications_none
                : Icons.notifications_active,
          ),
        ),
        title: Text(notification["title"]),
        subtitle: Text(notification["message"]),
        trailing: Text(notification["time"]),
      ),
    );
  }
}
