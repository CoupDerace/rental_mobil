import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/app/routes/routes.dart';
import 'package:rental_mobil/shared/providers/auth_provider.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.role;
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, auth),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                children: _buildMenuItems(context, role),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthProvider auth) {
    final nama = auth.profile?['nama'] ?? '-';
    final role = auth.role;
    final roleDisplay = role.toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 24,
            child: Text(
              nama.isNotEmpty ? nama[0].toUpperCase() : '-',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  roleDisplay,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuItems(BuildContext context, String role) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final r = role.toLowerCase();

    if (r == 'admin') {
      return [
        _item(context, Icons.dashboard, "Dashboard", AppRoutes.dashboard, currentRoute),
        const SizedBox(height: 16),
        _header("MASTER DATA"),
        _item(context, Icons.directions_car, "Mobil", AppRoutes.cars, currentRoute),
        _item(context, Icons.people, "Pelanggan", AppRoutes.pelanggan, currentRoute),
        _item(context, Icons.badge, "Karyawan", AppRoutes.karyawan, currentRoute),
        _item(context, Icons.admin_panel_settings, "Users", AppRoutes.users, currentRoute),
        const SizedBox(height: 16),
        _header("TRANSAKSI"),
        _item(context, Icons.receipt_long, "Rental", AppRoutes.transactions, currentRoute),
        _item(context, Icons.payments, "Pembayaran", AppRoutes.payment, currentRoute),
        _item(context, Icons.keyboard_return, "Pengembalian", AppRoutes.pengembalian, currentRoute),
        _item(context, Icons.build, "Servis", AppRoutes.services, currentRoute),
        const SizedBox(height: 16),
        _header("LAPORAN"),
        _item(context, Icons.bar_chart, "Reports", AppRoutes.reports, currentRoute),
        const SizedBox(height: 16),
        _header("SETTINGS"),
        _item(context, Icons.settings, "Settings", AppRoutes.settings, currentRoute),
        const SizedBox(height: 16),
        _header("AKSI"),
        _logoutItem(context),
      ];
    } else if (r == 'owner') {
      return [
        _item(context, Icons.dashboard, "Dashboard", AppRoutes.ownerDashboard, currentRoute),
        const SizedBox(height: 16),
        _header("LAPORAN"),
        _item(context, Icons.bar_chart, "Reports", AppRoutes.reports, currentRoute),
        const SizedBox(height: 16),
        _header("SETTINGS"),
        _item(context, Icons.settings, "Settings", AppRoutes.settings, currentRoute),
        const SizedBox(height: 16),
        _header("AKSI"),
        _logoutItem(context),
      ];
    } else {
      // Operator
      return [
        _item(context, Icons.dashboard, "Dashboard", AppRoutes.operatorDashboard, currentRoute),
        const SizedBox(height: 16),
        _header("TRANSAKSI"),
        _item(context, Icons.build, "Servis", AppRoutes.services, currentRoute),
        const SizedBox(height: 16),
        _header("SETTINGS"),
        _item(context, Icons.settings, "Settings", AppRoutes.settings, currentRoute),
        const SizedBox(height: 16),
        _header("AKSI"),
        _logoutItem(context),
      ];
    }
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF94A3B8),
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String route,
    String? currentRoute,
  ) {
    final isSelected = currentRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF7A1A) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        selected: isSelected,
        selectedColor: Colors.white,
        iconColor: const Color(0xFF94A3B8),
        textColor: const Color(0xFF94A3B8),
        leading: Icon(icon, color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            fontFamily: 'Inter',
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          if (currentRoute != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }

  Widget _logoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.red,
          fontFamily: 'Inter',
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        _showLogoutDialog(context);
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final auth = context.read<AuthProvider>();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await auth.logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (route) => false,
                );
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
