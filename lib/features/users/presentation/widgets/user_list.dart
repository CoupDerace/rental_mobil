import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../domain/entities/user.dart';
import '../providers/users_provider.dart';
import 'user_form.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsersProvider>();
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.role == 'admin';

    if (provider.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(
          "Error: ${provider.error}",
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final list = provider.filteredUsers;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data user"),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          const DataColumn(label: Text("Nama")),
          const DataColumn(label: Text("Email")),
          const DataColumn(label: Text("Role")),
          const DataColumn(label: Text("Nomor HP")),
          const DataColumn(label: Text("Created At")),
          if (isAdmin) const DataColumn(label: Text("Aksi")),
        ],
        rows: list.map((u) {
          final role = u.role.toLowerCase();
          Color roleColor;
          Color roleBg;
          if (role == 'admin') {
            roleColor = Colors.red;
            roleBg = Colors.red.withValues(alpha: 0.15);
          } else if (role == 'owner') {
            roleColor = Colors.orange;
            roleBg = Colors.orange.withValues(alpha: 0.15);
          } else {
            roleColor = Colors.blue;
            roleBg = Colors.blue.withValues(alpha: 0.15);
          }

          return DataRow(
            cells: [
              DataCell(Text(u.nama)),
              DataCell(Text(u.email)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: roleBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    u.role.toUpperCase(),
                    style: TextStyle(
                      color: roleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              DataCell(Text(u.noHp ?? '-')),
              DataCell(Text(u.createdAt != null 
                  ? DateFormat('dd MMM yyyy HH:mm').format(u.createdAt!) 
                  : '-')),
              if (isAdmin)
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Edit",
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => _showEditDialog(context, provider, u),
                      ),
                      IconButton(
                        tooltip: "Hapus",
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _confirmDelete(context, provider, u.id),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showEditDialog(BuildContext context, UsersProvider provider, User user) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: AlertDialog(
          title: const Text("Edit User"),
          content: SingleChildScrollView(
            child: UserForm(user: user),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, UsersProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus User"),
        content: const Text("Apakah Anda yakin ingin menghapus user ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await provider.deleteUser(id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menghapus: $e")),
                  );
                }
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
