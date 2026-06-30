import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/cars/presentation/providers/car_provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../widgets/car_form.dart';
import '../widgets/car_list.dart';

import '../../../../shared/providers/auth_provider.dart';
import '../../../../app/routes/routes.dart';

class CarsPage extends StatelessWidget {
  const CarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final role = auth.role.toLowerCase();

    if (role == 'owner') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.ownerDashboard);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (role == 'operator') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.operatorDashboard);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider(
      create: (_) => sl<CarsProvider>()..fetchCars(),
      child: Consumer<CarsProvider>(
        builder: (context, provider, child) {
          return AppScaffold(
            title: "Master Data Mobil",
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _showAddDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text("Tambah Mobil"),
              backgroundColor: const Color(0xFFFF7A1A),
              foregroundColor: Colors.white,
            ),
            body: RefreshIndicator(
              onRefresh: () => provider.fetchCars(),
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
                            "Daftar Mobil",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Kelola data armada kendaraan rental",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
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
                          hintText: "Cari Mobil (Nama, Tipe, Plat Nomor)...",
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
                      child: CarList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Pagination Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menampilkan ${provider.filteredCars.length} dari ${provider.cars.length} Mobil",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'Inter',
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {},
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF7A1A).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "1",
                              style: TextStyle(
                                color: Color(0xFFFF7A1A),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {},
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

  void _showAddDialog(BuildContext context, CarsProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: const AlertDialog(
          title: Text("Tambah Mobil Baru"),
          content: SingleChildScrollView(
            child: CarForm(),
          ),
        ),
      ),
    );
  }
}
