import 'package:flutter/material.dart';

class _NavItem {
  final String id;
  final String label;
  final IconData icon;
  final List<String> roles;

  const _NavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.roles,
  });
}

class AppDrawer extends StatelessWidget {
  final String currentPage;
  final String userRole;
  final void Function(String page) onNavigate;
  final VoidCallback onLogout;
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const AppDrawer({
    super.key,
    required this.currentPage,
    required this.userRole,
    required this.onNavigate,
    required this.onLogout,
    required this.themeMode,
    required this.onToggleTheme,
  });

  static const List<_NavItem> _menuItems = [
    _NavItem(
      id: 'dashboard',
      label: 'Dashboard',
      icon: Icons.dashboard_rounded,
      roles: ['admin', 'owner'],
    ),
    _NavItem(
      id: 'master-data',
      label: 'Master Data',
      icon: Icons.storage_rounded,
      roles: ['admin'],
    ),
    _NavItem(
      id: 'transactions',
      label: 'Transaksi',
      icon: Icons.receipt_long_rounded,
      roles: ['admin'],
    ),
    _NavItem(
      id: 'reports',
      label: 'Laporan',
      icon: Icons.description_rounded,
      roles: ['admin'],
    ),
    _NavItem(
      id: 'notifications',
      label: 'Notifikasi',
      icon: Icons.notifications_rounded,
      roles: ['admin'],
    ),
    _NavItem(
      id: 'settings',
      label: 'Pengaturan',
      icon: Icons.settings_rounded,
      roles: ['admin'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = themeMode == ThemeMode.dark;

    final filteredItems = _menuItems
        .where((item) => item.roles.contains(userRole))
        .toList();

    final roleLabel = userRole == 'admin' ? 'Administrator' : 'Owner';
    final dashboardLabel =
        userRole == 'owner' ? 'Owner Dashboard' : 'Dashboard';

    return Drawer(
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            decoration: BoxDecoration(
              color: colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.directions_car_rounded,
                    color: colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'MULTI RENTCAR',
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  roleLabel,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimary.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          // Nav items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              children: filteredItems.map((item) {
                final label =
                    item.id == 'dashboard' ? dashboardLabel : item.label;
                final isActive = currentPage == item.id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    title: Text(
                      label,
                      style: textTheme.titleMedium?.copyWith(
                        color: isActive
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isActive,
                    selectedTileColor:
                        colorScheme.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () => onNavigate(item.id),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 2),
                  ),
                );
              }).toList(),
            ),
          ),

          // Footer
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    isDark ? 'Light Mode' : 'Dark Mode',
                    style: textTheme.titleMedium,
                  ),
                  onTap: onToggleTheme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout_rounded,
                    color: colorScheme.error,
                  ),
                  title: Text(
                    'Keluar',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    onLogout();
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
