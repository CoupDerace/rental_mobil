import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/injector.dart';
import '../../../../app/routes/routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/service_provider.dart';
import '../widgets/service_form.dart';
import '../widgets/service_table.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final role = auth.role.toLowerCase();

    // Redirect Owner
    if (role == 'owner') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.ownerDashboard);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider(
      create: (_) => sl<ServiceProvider>()..fetchServices(),
      child: Consumer<ServiceProvider>(
        builder: (context, provider, child) {
          return AppScaffold(
            title: "Data Servis Mobil",
            body: RefreshIndicator(
              onRefresh: () => provider.fetchServices(),
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Daftar Servis Mobil",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Kelola data perbaikan, servis berkala, dan ganti oli mobil",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text("Tambah Servis"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF7A1A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onPressed: () => _showAddDialog(context, provider),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Search Bar
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: theme.dividerColor),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: TextField(
                        controller: provider.searchController,
                        decoration: InputDecoration(
                          hintText: "Cari Servis (Nama Mobil, Plat Nomor, Jenis Servis)...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                        onChanged: provider.onSearchChanged,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Table Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: theme.dividerColor),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: ServiceTable(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pagination Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menampilkan ${provider.paginatedServices.length} dari ${provider.filteredServices.length} Servis",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: provider.currentPage > 1 ? provider.previousPage : null,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7A1A).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${provider.currentPage}",
                              style: const TextStyle(
                                color: Color(0xFFFF7A1A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: provider.currentPage < provider.totalPages ? provider.nextPage : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context, ServiceProvider provider) async {
    await provider.fetchCars();
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: const AlertDialog(
          title: Text("Tambah Servis Baru"),
          content: SingleChildScrollView(
            child: ServiceForm(),
          ),
        ),
      ),
    );
  }
}
