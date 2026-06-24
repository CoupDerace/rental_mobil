import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notifications_filter.dart';
import '../widgets/notifications_list.dart';


class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationsProvider(),
      child: const AppScaffold(
        title: "Notifikasi",
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              NotificationFilter(),

              SizedBox(height: 20),

              NotificationList(),
            ],
          ),
        ),
      ),
    );
  }
}
