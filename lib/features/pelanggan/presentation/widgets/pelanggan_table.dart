import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/pelanggan.dart';
import '../providers/pelanggan_provider.dart';
import 'pelanggan_form.dart';

class PelangganTable extends StatelessWidget {
  const PelangganTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PelangganProvider>();

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

    final list = provider.filteredPelanggan;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data pelanggan"),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("Nama")),
          DataColumn(label: Text("No HP")),
          DataColumn(label: Text("Alamat")),
          DataColumn(label: Text("Jenis Identitas")),
          DataColumn(label: Text("No Identitas")),
          DataColumn(label: Text("Foto Identitas")),
          DataColumn(label: Text("Aksi")),
        ],
        rows: list.map((p) {
          return DataRow(
            cells: [
              DataCell(Text(p.nama)),
              DataCell(Text(p.noHp)),
              DataCell(Text(p.alamat ?? '-')),
              DataCell(Text(p.jenisIdentitas)),
              DataCell(Text(p.noIdentitas)),
              DataCell(
                p.fotoIdentitas == null || p.fotoIdentitas!.isEmpty
                    ? const Text("Belum Upload")
                    : TextButton.icon(
                        icon: const Icon(Icons.visibility, size: 16),
                        label: const Text("Lihat"),
                        onPressed: () => _showPreviewDialog(context, p.fotoIdentitas!),
                      ),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: () => _showEditDialog(context, provider, p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: () => _confirmDelete(context, provider, p.id),
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

  void _showPreviewDialog(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Preview Foto Identitas"),
        content: SizedBox(
          width: 400,
          height: 400,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InteractiveViewer(
              panEnabled: true,
              boundaryMargin: const EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(
                url,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text("Gagal memuat gambar"));
                },
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, PelangganProvider provider, Pelanggan pelanggan) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: AlertDialog(
          title: const Text("Edit Pelanggan"),
          content: SingleChildScrollView(
            child: PelangganForm(pelanggan: pelanggan),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PelangganProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pelanggan"),
        content: const Text("Apakah Anda yakin ingin menghapus data pelanggan ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await provider.deletePelanggan(id);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menghapus: $e")),
                  );
                }
              }
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
