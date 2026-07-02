import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/services/notification_checker.dart';
import '../providers/notification_provider.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final role = context.read<AuthProvider>().role;
      context.read<NotificationProvider>().fetchNotifications(role);
    });
  }

  Map<String, List<NotificationEntity>> _groupNotifications(
    List<NotificationEntity> list,
  ) {
    final Map<String, List<NotificationEntity>> grouped = {
      'Hari Ini': [],
      'Kemarin': [],
      'Sebelumnya': [],
    };

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var notification in list) {
      final date = notification.createdAt;
      final compareDate = DateTime(date.year, date.month, date.day);

      if (compareDate.isAtSameMomentAs(today)) {
        grouped['Hari Ini']!.add(notification);
      } else if (compareDate.isAtSameMomentAs(yesterday)) {
        grouped['Kemarin']!.add(notification);
      } else {
        grouped['Sebelumnya']!.add(notification);
      }
    }

    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }

  Widget _buildTypeBadge(String type) {
    String text = 'Pemberitahuan';
    Color color = Colors.grey;

    if (type == 'rental_due') {
      text = 'Jatuh Tempo';
      color = Colors.orange;
    } else if (type == 'overdue_rental') {
      text = 'Terlambat';
      color = Colors.red;
    } else if (type == 'service') {
      text = 'Servis';
      color = Colors.blue;
    } else if (type == 'service_completed') {
      text = 'Servis Selesai';
      color = Colors.green;
    } else if (type == 'rental_completed') {
      text = 'Rental Selesai';
      color = Colors.teal;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationProvider = context.watch<NotificationProvider>();
    final authProvider = context.watch<AuthProvider>();

    final role = authProvider.role.toLowerCase();

    if (role == 'owner') {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Notifikasi"),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              "Notifikasi hanya tersedia untuk Admin dan Operator",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final canUpdate = role == 'admin' || role == 'operator';

    final grouped = _groupNotifications(notificationProvider.notifications);
    final unreadList =
        notificationProvider.notifications.where((n) => !n.isRead).toList();

    return AppScaffold(
      title: "Notifikasi",
      actions: [
        if (canUpdate && unreadList.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.mark_email_read_outlined),
            tooltip: "Tandai Semua Dibaca",
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              await notificationProvider.markAllAsRead();
              messenger.showSnackBar(
                const SnackBar(
                  content: Text("Semua notifikasi ditandai dibaca"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
      ],
      body: Column(
        children: [
          if (kDebugMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _buildSimulationButtons(context),
            ),
          Expanded(
            child: notificationProvider.loading
                ? const Center(child: CircularProgressIndicator())
                : notificationProvider.error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Gagal memuat notifikasi",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(notificationProvider.error!),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed:
                          () => notificationProvider.fetchNotifications(role),
                      child: const Text("Coba Lagi"),
                    ),
                  ],
                ),
              )
              : notificationProvider.notifications.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 64,
                      color: theme.disabledColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Tidak ada notifikasi",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.disabledColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
              : RefreshIndicator(
                onRefresh: () => notificationProvider.fetchNotifications(role),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: grouped.keys.length,
                  itemBuilder: (context, groupIndex) {
                    final groupTitle = grouped.keys.elementAt(groupIndex);
                    final items = grouped[groupTitle]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          child: Text(
                            groupTitle,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF7A1A),
                            ),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            final formattedTime = DateFormat(
                              'HH:mm',
                            ).format(item.createdAt);
                            final formattedDate = DateFormat(
                              'dd MMM yyyy',
                            ).format(item.createdAt);

                            return Card(
                              elevation: 0,
                              color:
                                  item.isRead
                                      ? theme.cardColor
                                      : theme.colorScheme.primaryContainer
                                          .withValues(alpha: 0.15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color:
                                      item.isRead
                                          ? theme.dividerColor
                                          : theme.colorScheme.primary
                                              .withValues(alpha: 0.3),
                                  width: item.isRead ? 1 : 1.5,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Unread Indicator Dot
                                    if (!item.isRead)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 4,
                                          right: 8,
                                        ),
                                        child: Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildTypeBadge(item.type),
                                              Text(
                                                "$formattedDate, $formattedTime",
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                      color:
                                                          theme.disabledColor,
                                                      fontSize: 10,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            item.title,
                                            style: theme.textTheme.titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 4),
                                            Text(
                                              item.message,
                                              style: theme.textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color
                                                        ?.withValues(alpha: 0.8),
                                                  ),
                                            ),
                                            if ((item.type == 'rental_due' || item.type == 'overdue_rental') && item.actionUrl != null && item.actionUrl!.isNotEmpty) ...[
                                              const SizedBox(height: 8),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: ElevatedButton.icon(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.green.withValues(alpha: 0.15),
                                                    foregroundColor: Colors.green,
                                                    elevation: 0,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(8),
                                                      side: const BorderSide(color: Colors.green),
                                                    ),
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                  ),
                                                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                                                  label: const Text(
                                                    'WA',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                   onPressed: () async {
                                                     try {
                                                       final uri = Uri.parse(item.actionUrl!);
                                                       await launchUrl(
                                                         uri,
                                                         mode: LaunchMode.externalApplication,
                                                       );
                                                     } catch (e) {
                                                       debugPrint('Error launching WhatsApp custom scheme: $e');
                                                       try {
                                                         final webUrl = item.actionUrl!.replaceAll('whatsapp://send?', 'https://wa.me/?');
                                                         await launchUrl(
                                                           Uri.parse(webUrl),
                                                           mode: LaunchMode.externalApplication,
                                                         );
                                                       } catch (_) {}
                                                     }
                                                   },
                                                ),
                                              ),
                                            ],
                                        ],
                                      ),
                                    ),
                                    if (canUpdate) ...[
                                      const SizedBox(width: 8),
                                      Column(
                                        children: [
                                          if (!item.isRead)
                                            IconButton(
                                              icon: const Icon(
                                                Icons.check_circle_outline,
                                                size: 20,
                                                color: Colors.green,
                                              ),
                                              tooltip: "Tandai dibaca",
                                              onPressed:
                                                  () => notificationProvider
                                                      .markAsRead(item.id),
                                              constraints:
                                                  const BoxConstraints(),
                                              padding: const EdgeInsets.all(4),
                                            ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              size: 20,
                                              color: Colors.red,
                                            ),
                                            tooltip: "Hapus",
                                            onPressed: () async {
                                              final messenger = ScaffoldMessenger.of(context);
                                              await notificationProvider
                                                  .deleteNotification(item.id);
                                              messenger.showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Notifikasi dihapus",
                                                  ),
                                                  backgroundColor:
                                                      Colors.grey,
                                                ),
                                              );
                                            },
                                            constraints: const BoxConstraints(),
                                            padding: const EdgeInsets.all(4),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

  Widget _buildSimulationButtons(BuildContext context) {
    final role = context.read<AuthProvider>().role.toLowerCase();
    if (role == 'owner') return const SizedBox.shrink();

    final isAdmin = role == 'admin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSimulationButton(
              context: context,
              label: 'Servis',
              icon: Icons.build,
              color: Colors.blue,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final provider = context.read<NotificationProvider>();
                await NotificationChecker.checkServiceNotifications();
                await provider.fetchNotifications(role);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Simulasi notifikasi servis berhasil')),
                );
              },
            ),
            if (isAdmin) ...[
              _buildSimulationButton(
                context: context,
                label: 'Rental Due',
                icon: Icons.event,
                color: const Color(0xFFFF7A1A),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final provider = context.read<NotificationProvider>();
                  await NotificationChecker.checkRentalDueNotifications();
                  await provider.fetchNotifications(role);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Simulasi rental jatuh tempo berhasil')),
                  );
                },
              ),
              _buildSimulationButton(
                context: context,
                label: 'Overdue',
                icon: Icons.warning_amber,
                color: Colors.red,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final provider = context.read<NotificationProvider>();
                  await NotificationChecker.checkOverdueNotifications();
                  await provider.fetchNotifications(role);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Simulasi mobil terlambat berhasil')),
                  );
                },
              ),
            ],
            _buildSimulationButton(
              context: context,
              label: 'Servis Selesai',
              icon: Icons.check_circle_outline,
              color: Colors.green,
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final provider = context.read<NotificationProvider>();
                await NotificationChecker.checkServiceCompletedNotifications();
                await provider.fetchNotifications(role);
                messenger.showSnackBar(
                  const SnackBar(content: Text('Simulasi servis selesai berhasil')),
                );
              },
            ),
            if (isAdmin)
              _buildSimulationButton(
                context: context,
                label: 'Rental Selesai',
                icon: Icons.assignment_turned_in_outlined,
                color: Colors.teal,
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final provider = context.read<NotificationProvider>();
                  await NotificationChecker.checkRentalCompletedNotifications();
                  await provider.fetchNotifications(role);
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Simulasi pengembalian selesai berhasil')),
                  );
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(height: 1),
      ],
    );
  }

  Widget _buildSimulationButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.15),
        foregroundColor: color,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }
}
