import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../shared/providers/auth_provider.dart';
import '../../data/models/payment_model.dart';
import '../providers/payment_provider.dart';
import 'payment_form.dart';

class PaymentTable extends StatelessWidget {
  const PaymentTable({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();
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

    final list = provider.paginatedPayments;

    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("Tidak ada data pembayaran"),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        columns: [
          const DataColumn(label: Text("Pelanggan")),
          const DataColumn(label: Text("Mobil")),
          const DataColumn(label: Text("Tanggal Bayar")),
          const DataColumn(label: Text("Jumlah Bayar")),
          const DataColumn(label: Text("Metode")),
          const DataColumn(label: Text("Status")),
          if (isAdmin) const DataColumn(label: Text("Aksi")),
        ],
        rows: list.map((p) {
          final paymentModel = p as PaymentModel;
          final status = p.statusPembayaran.toLowerCase();

          Color statusColor;
          Color statusBg;
          if (status == 'lunas') {
            statusColor = Colors.green;
            statusBg = Colors.green.withValues(alpha: 0.15);
          } else if (status == 'pending') {
            statusColor = Colors.orange;
            statusBg = Colors.orange.withValues(alpha: 0.15);
          } else {
            statusColor = Colors.red;
            statusBg = Colors.red.withValues(alpha: 0.15);
          }

          return DataRow(
            cells: [
              DataCell(Text(paymentModel.namaPelanggan ?? '-')),
              DataCell(Text(paymentModel.namaMobil ?? '-')),
              DataCell(Text(dateFormat.format(p.tanggalBayar))),
              DataCell(Text(currencyFormat.format(p.jumlahBayar))),
              DataCell(Text(p.metodePembayaran)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    p.statusPembayaran.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (isAdmin)
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        tooltip: "Edit",
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () => _showEditDialog(context, provider, paymentModel),
                      ),
                      IconButton(
                        tooltip: "Hapus",
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

  void _showEditDialog(BuildContext context, PaymentProvider provider, PaymentModel payment) {
    showDialog(
      context: context,
      builder: (ctx) => ChangeNotifierProvider.value(
        value: provider,
        child: AlertDialog(
          title: const Text("Edit Pembayaran"),
          content: SingleChildScrollView(
            child: PaymentForm(payment: payment),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PaymentProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Pembayaran"),
        content: const Text("Apakah Anda yakin ingin menghapus data pembayaran ini?"),
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
                await provider.deletePayment(id);
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
