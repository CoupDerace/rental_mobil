import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/karyawan.dart';
import '../providers/karyawan_provider.dart';
import 'karyawan_form.dart';

class KaryawanTable extends StatelessWidget {
  final List<KaryawanEntity> karyawanList;
  const KaryawanTable({super.key, required this.karyawanList});

  @override
  Widget build(BuildContext context) {
    if (karyawanList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text('Tidak ada data karyawan'),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Nama Karyawan')),
          DataColumn(label: Text('Jabatan')),
          DataColumn(label: Text('Nomor HP')),
          DataColumn(label: Text('Tanggal Masuk')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Aksi')),
        ],
        rows: karyawanList.map((k) => _buildRow(context, k)).toList(),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, KaryawanEntity k) {
    final isAktif = k.statusKaryawan.toLowerCase() == 'aktif';
    return DataRow(cells: [
      DataCell(Text(k.namaKaryawan)),
      DataCell(Text(k.jabatan[0].toUpperCase() + k.jabatan.substring(1))),
      DataCell(Text(k.noHp)),
      DataCell(Text(k.tanggalMasuk)),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isAktif
                ? Colors.green.withValues(alpha: 0.15)
                : Colors.grey.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isAktif ? 'Aktif' : 'Nonaktif',
            style: TextStyle(
              color: isAktif ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
      DataCell(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
              onPressed: () => _showEditDialog(context, k),
            ),
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete, color: Colors.red, size: 20),
              onPressed: () =>
                  _confirmDelete(context, context.read<KaryawanProvider>(), k),
            ),
          ],
        ),
      ),
    ]);
  }

  void _showEditDialog(BuildContext context, KaryawanEntity karyawan) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: context.read<KaryawanProvider>(),
        child: AlertDialog(
          title: const Text('Edit Karyawan'),
          content: SingleChildScrollView(
            child: KaryawanForm(karyawan: karyawan),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, KaryawanProvider provider, KaryawanEntity k) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Karyawan'),
        content: Text(
            'Apakah Anda yakin ingin menghapus "${k.namaKaryawan}"?\nTindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await provider.deleteKaryawan(k.id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus: $e')),
                  );
                }
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
