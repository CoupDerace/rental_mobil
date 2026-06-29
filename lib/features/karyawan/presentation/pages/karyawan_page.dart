import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/injector.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/karyawan_provider.dart';
import '../widgets/karyawan_form.dart';
import '../widgets/karyawan_table.dart';

import '../../../../shared/providers/auth_provider.dart';
import '../../../../app/routes/routes.dart';

class KaryawanPage extends StatelessWidget {
  const KaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.role.toLowerCase();

    if (role == 'operator') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.operatorDashboard);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider(
      create: (_) => sl<KaryawanProvider>()..fetchKaryawan(),
      child: Consumer<KaryawanProvider>(
        builder: (context, provider, _) {
          return AppScaffold(
            title: 'Data Karyawan',
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text('Tambah'),
            ),
            body: Column(
              children: [
                // Search bar + refresh
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: provider.searchController,
                          decoration: InputDecoration(
                            hintText: 'Cari karyawan...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: provider.onSearchChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: 'Refresh',
                        icon: const Icon(Icons.refresh),
                        onPressed: provider.fetchKaryawan,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Content
                Expanded(
                  child: _buildContent(context, provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, KaryawanProvider provider) {
    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text('Terjadi kesalahan:\n${provider.error}',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: provider.fetchKaryawan,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }
    if (provider.filteredKaryawan.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              provider.searchController.text.isEmpty
                  ? 'Belum ada data karyawan'
                  : 'Tidak ada karyawan yang cocok',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: KaryawanTable(karyawanList: provider.filteredKaryawan),
    );
  }

  void _showAddDialog(BuildContext context, KaryawanProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: const AlertDialog(
          title: Text('Tambah Karyawan'),
          content: SingleChildScrollView(child: KaryawanForm()),
        ),
      ),
    );
  }
}
