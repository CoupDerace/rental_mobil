import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../core/network/supabase_service.dart';
import 'package:flutter/services.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../shared/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  late TextEditingController _roleController;

  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isSavingProfile = false;
  bool _isSavingPassword = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final profile = auth.profile ?? {};

    _namaController = TextEditingController(text: profile['nama']?.toString() ?? '');
    _emailController = TextEditingController(text: profile['email']?.toString() ?? '');
    _noHpController = TextEditingController(text: profile['no_hp']?.toString() ?? '');
    _roleController = TextEditingController(text: (profile['role']?.toString() ?? '').toUpperCase());
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _roleController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;

    setState(() {
      _isSavingProfile = true;
    });

    try {
      final auth = context.read<AuthProvider>();
      final user = auth.user;

      if (user != null) {
        await SupabaseService.from('users').update({
          'nama': _namaController.text.trim(),
          'email': _emailController.text.trim(),
          'no_hp': _noHpController.text.trim(),
        }).eq('auth_user_id', user.id);

        if (mounted) {
          final messenger = ScaffoldMessenger.of(context);
          await auth.loadSession();
          messenger.showSnackBar(
            const SnackBar(
              content: Text("Profil berhasil diperbarui"),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memperbarui profil: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingProfile = false;
        });
      }
    }
  }

  Future<void> _updatePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;

    setState(() {
      _isSavingPassword = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: _newPasswordController.text),
      );

      _oldPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal memperbarui password: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSavingPassword = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return AppScaffold(
      title: "Pengaturan",
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Section 1: Profil Pengguna
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _profileFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Profil Pengguna",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: "Nama Lengkap",
                        prefixIcon: Icon(Icons.person),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                      ],
                      validator: (v) => v == null || v.trim().isEmpty ? "Nama wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return "Email wajib diisi";
                        if (!v.contains('@')) return "Email tidak valid";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _noHpController,
                      decoration: const InputDecoration(
                        labelText: "No. HP",
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? "No. HP wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _roleController,
                      readOnly: true,
                      enabled: false,
                      decoration: const InputDecoration(
                        labelText: "Hak Akses (Role)",
                        prefixIcon: Icon(Icons.admin_panel_settings),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A1A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isSavingProfile ? null : _updateProfile,
                        child: _isSavingProfile
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text("Simpan Profil"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 2: Ubah Password
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _passwordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ubah Password",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _oldPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password Lama",
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) => v == null || v.isEmpty ? "Password lama wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password Baru",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Password baru wajib diisi";
                        if (v.length < 6) return "Password minimal 6 karakter";
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Konfirmasi Password Baru",
                        prefixIcon: Icon(Icons.lock_reset),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return "Konfirmasi password wajib diisi";
                        if (v != _newPasswordController.text) return "Password konfirmasi tidak cocok";
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A1A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _isSavingPassword ? null : _updatePassword,
                        child: _isSavingPassword
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text("Perbarui Password"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 3: Role Information Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informasi Hak Akses",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRoleInfoRow(
                    context,
                    role: "ADMIN",
                    desc: "Memiliki hak penuh untuk mengelola master data, rental, pengembalian, pembayaran, servis, dan laporan.",
                    color: Colors.blue,
                  ),
                  const Divider(height: 24),
                  _buildRoleInfoRow(
                    context,
                    role: "OWNER",
                    desc: "Memiliki akses untuk melihat Dashboard, Laporan, Pembayaran, Pengembalian, dan mengunduh berkas laporan.",
                    color: Colors.orange,
                  ),
                  const Divider(height: 24),
                  _buildRoleInfoRow(
                    context,
                    role: "OPERATOR",
                    desc: "Memiliki akses khusus untuk mengelola data perbaikan/servis mobil dan memantau Dashboard Service.",
                    color: Colors.teal,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Section 4: Theme Settings Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: SwitchListTile(
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: const Color(0xFFFF7A1A),
              ),
              title: const Text(
                "Mode Gelap (Dark Mode)",
                style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Aktifkan tampilan gelap untuk kenyamanan mata Anda",
                style: TextStyle(fontFamily: 'Inter', fontSize: 12),
              ),
              value: themeProvider.isDarkMode,
              activeTrackColor: const Color(0xFFFF7A1A),
              onChanged: themeProvider.toggleTheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleInfoRow(
    BuildContext context, {
    required String role,
    required String desc,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            role,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            desc,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
