import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/notifications/presentation/providers/notification_provider.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../app/routes/routes.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role = context.read<AuthProvider>().role;
      context.read<NotificationProvider>().getUnreadCount(role);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final role = authProvider.role.toLowerCase();

    if (role == 'owner') {
      return const SizedBox.shrink();
    }

    final unreadCount = context.watch<NotificationProvider>().unreadCount;

    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.notifications);
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                unreadCount > 99 ? '99+' : '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
