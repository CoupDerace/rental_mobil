import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const SettingsScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifEnabled = true;
  bool _emailNotif = false;
  bool _autoBackup = true;
  String _currency = 'IDR';
  String _language = 'Bahasa Indonesia';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = widget.themeMode == ThemeMode.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pengaturan', style: textTheme.headlineMedium),
          const SizedBox(height: 4),
          Text(
            'Konfigurasi aplikasi dan preferensi pengguna',
            style: textTheme.bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 24),

          // Profile Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.primary.withOpacity(0.12),
                    child: Icon(
                      Icons.person_rounded,
                      size: 36,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Administrator',
                            style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('admin@multirentcar.id',
                            style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Admin',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    onPressed: () => _showEditProfileDialog(),
                    tooltip: 'Edit Profil',
                    color: colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Appearance
          _SettingsSection(
            title: 'Tampilan',
            icon: Icons.palette_rounded,
            children: [
              _SwitchTile(
                leading: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: colorScheme.primary,
                ),
                title: 'Dark Mode',
                subtitle: isDark ? 'Mode gelap aktif' : 'Mode terang aktif',
                value: isDark,
                onChanged: (_) => widget.onToggleTheme(),
              ),
              _DropdownTile(
                leading:
                    Icon(Icons.language_rounded, color: colorScheme.primary),
                title: 'Bahasa',
                value: _language,
                items: const ['Bahasa Indonesia', 'English'],
                onChanged: (v) => setState(() => _language = v!),
              ),
              _DropdownTile(
                leading: Icon(Icons.attach_money_rounded,
                    color: colorScheme.primary),
                title: 'Mata Uang',
                value: _currency,
                items: const ['IDR', 'USD', 'SGD'],
                onChanged: (v) => setState(() => _currency = v!),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Notifications
          _SettingsSection(
            title: 'Notifikasi',
            icon: Icons.notifications_rounded,
            children: [
              _SwitchTile(
                leading: Icon(Icons.notifications_active_rounded,
                    color: colorScheme.primary),
                title: 'Notifikasi Aplikasi',
                subtitle: 'Aktifkan pemberitahuan push',
                value: _notifEnabled,
                onChanged: (v) => setState(() => _notifEnabled = v),
              ),
              _SwitchTile(
                leading: Icon(Icons.email_rounded,
                    color: colorScheme.primary),
                title: 'Notifikasi Email',
                subtitle: 'Kirim ringkasan harian via email',
                value: _emailNotif,
                onChanged: _notifEnabled
                    ? (v) => setState(() => _emailNotif = v)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Data & System
          _SettingsSection(
            title: 'Data & Sistem',
            icon: Icons.storage_rounded,
            children: [
              _SwitchTile(
                leading: Icon(Icons.backup_rounded,
                    color: colorScheme.primary),
                title: 'Auto Backup',
                subtitle: 'Backup data otomatis setiap hari',
                value: _autoBackup,
                onChanged: (v) => setState(() => _autoBackup = v),
              ),
              _ActionTile(
                leading:
                    Icon(Icons.download_rounded, color: colorScheme.primary),
                title: 'Export Semua Data',
                subtitle: 'Unduh backup lengkap dalam format JSON',
                onTap: () => _showSnackBar('Sedang mengekspor data...'),
              ),
              _ActionTile(
                leading:
                    Icon(Icons.refresh_rounded, color: colorScheme.primary),
                title: 'Sinkronisasi Data',
                subtitle: 'Sinkronkan data dengan server',
                onTap: () => _showSnackBar('Sinkronisasi berhasil!'),
              ),
              _ActionTile(
                leading: Icon(Icons.delete_sweep_rounded,
                    color: colorScheme.error),
                title: 'Hapus Cache',
                subtitle: 'Bersihkan file sementara aplikasi',
                textColor: colorScheme.error,
                onTap: _showClearCacheDialog,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // About
          _SettingsSection(
            title: 'Tentang Aplikasi',
            icon: Icons.info_rounded,
            children: [
              _InfoTile(
                  label: 'Versi Aplikasi', value: '1.0.0'),
              _InfoTile(
                  label: 'Build', value: '2026.06.09'),
              _InfoTile(
                  label: 'Platform', value: 'Flutter 3.x'),
              _ActionTile(
                leading: Icon(Icons.description_rounded,
                    color: colorScheme.primary),
                title: 'Kebijakan Privasi',
                onTap: () =>
                    _showSnackBar('Membuka kebijakan privasi...'),
              ),
              _ActionTile(
                leading: Icon(Icons.gavel_rounded,
                    color: colorScheme.primary),
                title: 'Syarat & Ketentuan',
                onTap: () =>
                    _showSnackBar('Membuka syarat & ketentuan...'),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Nama', prefixIcon: Icon(Icons.person_rounded)),
              controller: TextEditingController(text: 'Administrator'),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email_rounded)),
              controller: TextEditingController(
                  text: 'admin@multirentcar.id'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar('Profil berhasil diperbarui');
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Cache'),
        content: const Text(
            'Apakah Anda yakin ingin membersihkan file cache aplikasi?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showSnackBar('Cache berhasil dihapus (2.4 MB)');
            },
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

// ─── Section Wrapper ───────────────────────────────────────────────────────

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: textTheme.titleMedium),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

// ─── Tile Variants ─────────────────────────────────────────────────────────

class _SwitchTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final bool value;
  final void Function(bool)? onChanged;

  const _SwitchTile({
    required this.leading,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: leading,
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      value: value,
      onChanged: onChanged,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String value;
  final List<String> items;
  final void Function(String?) onChanged;

  const _DropdownTile({
    required this.leading,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: leading,
      title: Text(title),
      trailing: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
          style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? textColor;

  const _ActionTile({
    required this.leading,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: textTheme.bodyLarge?.copyWith(color: textColor),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textColor ?? Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
