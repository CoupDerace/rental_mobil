import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/injector.dart';
import '../../../../app/routes/routes.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/users_provider.dart';
import '../widgets/user_form.dart';
import '../widgets/user_list.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final role = auth.role.toLowerCase();

    // Redirect Owner & Operator
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

    final isAdmin = role == 'admin';

    return ChangeNotifierProvider(
      create: (_) => sl<UsersProvider>()..fetchUsers(),
      child: Consumer<UsersProvider>(
        builder: (context, provider, child) {
          return AppScaffold(
            title: "Master Data User",
            floatingActionButton: isAdmin
                ? FloatingActionButton.extended(
                    onPressed: () => _showAddDialog(context, provider),
                    icon: const Icon(Icons.add),
                    label: const Text("Tambah User"),
                    backgroundColor: const Color(0xFFFF7A1A),
                    foregroundColor: Colors.white,
                  )
                : null,
            body: RefreshIndicator(
              onRefresh: () => provider.fetchUsers(),
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
                            "Daftar User",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Kelola data hak akses user aplikasi",
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
                          hintText: "Cari User (Nama, Email, Role)...",
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
                      child: UserList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Display total indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Menampilkan ${provider.filteredUsers.length} dari ${provider.usersList.length} User",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          fontFamily: 'Inter',
                        ),
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

  void _showAddDialog(BuildContext context, UsersProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: const AlertDialog(
          title: Text("Tambah User Baru"),
          content: SingleChildScrollView(
            child: UserForm(),
          ),
        ),
      ),
    );
  }
}
