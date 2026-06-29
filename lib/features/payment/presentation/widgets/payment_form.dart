import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../rental/data/models/rental_model.dart';
import '../../data/models/payment_model.dart';
import '../providers/payment_provider.dart';

class PaymentForm extends StatefulWidget {
  final PaymentModel? payment;
  const PaymentForm({super.key, this.payment});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedRentalId;
  DateTime? _tanggalBayar;
  double _jumlahBayar = 0.0;
  String _metodePembayaran = 'Cash';
  String _statusPembayaran = 'pending';

  late TextEditingController _tanggalBayarController;
  late TextEditingController _jumlahBayarController;

  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _displayDateFormat = DateFormat('dd MMM yyyy');
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _selectedRentalId = widget.payment?.rentalId;
    _tanggalBayar = widget.payment?.tanggalBayar;
    _jumlahBayar = widget.payment?.jumlahBayar ?? 0.0;
    _metodePembayaran = widget.payment?.metodePembayaran ?? 'Cash';
    _statusPembayaran = widget.payment?.statusPembayaran ?? 'pending';

    _tanggalBayarController = TextEditingController(
      text: _tanggalBayar != null ? _dateFormat.format(_tanggalBayar!) : '',
    );
    _jumlahBayarController = TextEditingController(
      text: _currencyFormat.format(_jumlahBayar),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchFormDependencies();
    });
  }

  void _onRentalChanged(String? rentalId) {
    if (rentalId == null) return;
    setState(() {
      _selectedRentalId = rentalId;
    });

    final rentals = context.read<PaymentProvider>().rentals;
    final selectedRental = rentals.firstWhere(
      (r) => r.id == rentalId,
      orElse: () => RentalModel(
        id: '',
        pelangganId: '',
        mobilId: '',
        tanggalSewa: DateTime.now(),
        tanggalKembali: DateTime.now(),
        totalBiaya: 0.0,
        statusRental: '',
      ),
    );

    if (selectedRental.id.isNotEmpty) {
      setState(() {
        _jumlahBayar = selectedRental.totalBiaya;
        _jumlahBayarController.text = _currencyFormat.format(_jumlahBayar);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalBayar ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tanggalBayar = picked;
        _tanggalBayarController.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PaymentProvider>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rental Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedRentalId,
            decoration: const InputDecoration(
              labelText: "Rental",
              prefixIcon: Icon(Icons.assignment),
            ),
            items: provider.rentals.map((r) {
              final rentalModel = r as RentalModel;
              final formattedDate = _displayDateFormat.format(r.tanggalSewa);
              final formattedCost = _currencyFormat.format(r.totalBiaya);
              return DropdownMenuItem<String>(
                value: r.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: _getMobilStatusColor(r.statusRental),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${rentalModel.namaPelanggan ?? 'Pelanggan'} - ${rentalModel.namaMobil ?? 'Mobil'} ($formattedDate) - $formattedCost",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: _onRentalChanged,
            validator: (v) => v == null ? "Rental wajib dipilih" : null,
          ),
          const SizedBox(height: 16),

          // Tanggal Bayar Picker
          TextFormField(
            controller: _tanggalBayarController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Tanggal Bayar",
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: () => _selectDate(context),
            validator: (v) => v == null || v.isEmpty ? "Tanggal bayar wajib diisi" : null,
          ),
          const SizedBox(height: 16),

          // Jumlah Bayar (Read Only)
          TextFormField(
            controller: _jumlahBayarController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Jumlah Bayar",
              prefixIcon: Icon(Icons.payments),
            ),
          ),
          const SizedBox(height: 16),

          // Metode Pembayaran Dropdown
          DropdownButtonFormField<String>(
            initialValue: _metodePembayaran,
            decoration: const InputDecoration(
              labelText: "Metode Pembayaran",
              prefixIcon: Icon(Icons.payment),
            ),
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'Transfer', child: Text('Transfer')),
              DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _metodePembayaran = val;
                });
              }
            },
            validator: (v) => v == null ? "Metode pembayaran wajib dipilih" : null,
          ),
          const SizedBox(height: 16),

          // Status Pembayaran Dropdown
          DropdownButtonFormField<String>(
            initialValue: _statusPembayaran,
            decoration: const InputDecoration(
              labelText: "Status Pembayaran",
              prefixIcon: Icon(Icons.info_outline),
            ),
            items: const [
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'lunas', child: Text('Lunas')),
              DropdownMenuItem(value: 'gagal', child: Text('Gagal')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _statusPembayaran = val;
                });
              }
            },
            validator: (v) => v == null ? "Status pembayaran wajib dipilih" : null,
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A1A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final data = {
                    'rental_id': _selectedRentalId,
                    'tanggal_bayar': _tanggalBayar,
                    'jumlah_bayar': _jumlahBayar,
                    'metode_pembayaran': _metodePembayaran,
                    'status_pembayaran': _statusPembayaran,
                  };

                  try {
                    if (widget.payment == null) {
                      await provider.addPayment(data);
                    } else {
                      await provider.updatePayment(widget.payment!.id, data);
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal menyimpan data: $e")),
                      );
                    }
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tanggalBayarController.dispose();
    _jumlahBayarController.dispose();
    super.dispose();
  }

  Color _getMobilStatusColor(String statusRental) {
    if (statusRental.toLowerCase() == 'aktif') {
      return Colors.orange; // disewa
    }
    return Colors.green; // tersedia
  }
}
