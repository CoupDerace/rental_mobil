import 'package:flutter/material.dart';
import 'package:rental_mobil/core/theme/app_theme.dart';
import 'package:rental_mobil/features/auth/data/models/car_model.dart';


class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<AppNotification> _notifications =
      List.from(SampleData.notifications);
  NotifType? _filterType;

  List<AppNotification> get _filtered {
    if (_filterType == null) return _notifications;
    return _notifications.where((n) => n.type == _filterType).toList();
  }

  int get _unreadCount =>
      _notifications.where((n) => !n.isRead).length;

  void _markAllRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = AppNotification(
          id: _notifications[i].id,
          message: _notifications[i].message,
          time: _notifications[i].time,
          type: _notifications[i].type,
          isRead: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Notifikasi', style: textTheme.headlineMedium),
                      if (_unreadCount > 0) ...[
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_unreadCount',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Semua pemberitahuan sistem',
                    style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
              if (_unreadCount > 0)
                TextButton.icon(
                  onPressed: _markAllRead,
                  icon: const Icon(Icons.done_all_rounded, size: 18),
                  label: const Text('Tandai Semua Dibaca'),
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'Semua',
                  icon: Icons.notifications_rounded,
                  isSelected: _filterType == null,
                  onTap: () => setState(() => _filterType = null),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Info',
                  icon: Icons.info_outline_rounded,
                  isSelected: _filterType == NotifType.info,
                  onTap: () =>
                      setState(() => _filterType = NotifType.info),
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Sukses',
                  icon: Icons.check_circle_outline_rounded,
                  isSelected: _filterType == NotifType.success,
                  onTap: () =>
                      setState(() => _filterType = NotifType.success),
                  color: AppTheme.successColor(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Peringatan',
                  icon: Icons.warning_amber_rounded,
                  isSelected: _filterType == NotifType.warning,
                  onTap: () =>
                      setState(() => _filterType = NotifType.warning),
                  color: AppTheme.warningColor(context),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Error',
                  icon: Icons.error_outline_rounded,
                  isSelected: _filterType == NotifType.error,
                  onTap: () =>
                      setState(() => _filterType = NotifType.error),
                  color: AppTheme.errorColor(context),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notifications list
          if (_filtered.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.notifications_off_rounded,
                          size: 48,
                          color: colorScheme.onSurfaceVariant),
                      const SizedBox(height: 12),
                      Text(
                        'Tidak ada notifikasi',
                        style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Card(
              child: Column(
                children: _filtered.asMap().entries.map((entry) {
                  final i = entry.key;
                  final notif = entry.value;
                  return Column(
                    children: [
                      _NotificationTile(notif: notif),
                      if (i < _filtered.length - 1)
                        Divider(
                          height: 1,
                          color: colorScheme.outline.withOpacity(0.4),
                          indent: 56,
                        ),
                    ],
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? effectiveColor.withOpacity(0.12)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? effectiveColor : colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected
                  ? effectiveColor
                  : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isSelected
                    ? effectiveColor
                    : colorScheme.onSurfaceVariant,
                fontWeight: isSelected
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final AppNotification notif;

  const _NotificationTile({required this.notif});

  Color _iconColor(BuildContext context) {
    switch (notif.type) {
      case NotifType.success:
        return AppTheme.successColor(context);
      case NotifType.warning:
        return AppTheme.warningColor(context);
      case NotifType.error:
        return AppTheme.errorColor(context);
      case NotifType.info:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData get _icon {
    switch (notif.type) {
      case NotifType.success:
        return Icons.check_circle_rounded;
      case NotifType.warning:
        return Icons.warning_amber_rounded;
      case NotifType.error:
        return Icons.error_rounded;
      case NotifType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = _iconColor(context);

    return InkWell(
      onTap: () {},
      child: Container(
        color: notif.isRead
            ? Colors.transparent
            : colorScheme.primary.withOpacity(0.04),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.message,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: notif.isRead
                          ? FontWeight.normal
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          size: 12,
                          color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        notif.time,
                        style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!notif.isRead)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
