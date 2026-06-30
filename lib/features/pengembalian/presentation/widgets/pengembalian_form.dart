import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../rental/data/models/rental_model.dart';
import '../../data/models/pengembalian_model.dart';
import '../providers/pengembalian_provider.dart';

class PengembalianForm extends StatefulWidget {
  final PengembalianModel? pengembalian;
  const PengembalianForm({super.key, this.pengembalian});

  @override
  State<PengembalianForm> createState() => _PengembalianFormState();
}

class _PengembalianFormState extends State<PengembalianForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedRentalId;
  DateTime? _tanggalKembali;
  double _denda = 0.0;
  String _kondisiMobil = 'Baik';

  late TextEditingController _tanggalKembaliController;
  late TextEditingController _dendaController;

  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _displayDateFormat = DateFormat('dd MMM yyyy');
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _selectedRentalId = widget.pengembalian?.rentalId;
    _tanggalKembali = widget.pengembalian?.tanggalKembali;
    _denda = widget.pengembalian?.denda ?? 0.0;
    _kondisiMobil = widget.pengembalian?.kondisiMobil ?? 'Baik';

    _tanggalKembaliController = TextEditingController(
      text: _tanggalKembali != null ? _dateFormat.format(_tanggalKembali!) : '',
    );
    _dendaController = TextEditingController(
      text: _currencyFormat.format(_denda),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PengembalianProvider>().fetchFormDependencies();
    });
  }

  void _calculateDenda() {
    if (_selectedRentalId == null || _tanggalKembali == null) {
      return;
    }

    final rentals = context.read<PengembalianProvider>().rentals;
    RentalModel? selectedRental;
    for (final r in rentals) {
      if (r.id == _selectedRentalId) {
        selectedRental = r as RentalModel;
        break;
      }
    }

    if (selectedRental == null) return;

    final expectedReturnDate = selectedRental.tanggalKembali;
    final lateDays = _tanggalKembali!.difference(expectedReturnDate).inDays;

    setState(() {
      if (lateDays > 0) {
        _denda = (lateDays * 100000).toDouble();
      } else {
        _denda = 0.0;
      }
      _dendaController.text = _currencyFormat.format(_denda);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalKembali ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tanggalKembali = picked;
        _tanggalKembaliController.text = _dateFormat.format(picked);
      });
      _calculateDenda();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PengembalianProvider>();

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rental Dropdown
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: _selectedRentalId,
            decoration: const InputDecoration(
              labelText: "Rental",
              prefixIcon: Icon(Icons.assignment),
            ),
            items: provider.rentals.map((r) {
              final rentalModel = r as RentalModel;
              final formattedSewa = _displayDateFormat.format(r.tanggalSewa);
              final formattedKembali = _displayDateFormat.format(r.tanggalKembali);
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
                    Expanded(
                      child: Text(
                        "${rentalModel.namaPelanggan ?? 'Pelanggan'} - ${rentalModel.namaMobil ?? 'Mobil'} (${rentalModel.platNomor ?? 'Plat'}) | $formattedSewa - $formattedKembali",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  _selectedRentalId = v;
                });
                _calculateDenda();
              }
            },
            validator: (v) => v == null ? "Rental wajib dipilih" : null,
          ),
          const SizedBox(height: 16),

          // Tanggal Kembali Picker
          TextFormField(
            controller: _tanggalKembaliController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Tanggal Kembali",
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: () => _selectDate(context),
            validator: (v) => v == null || v.isEmpty ? "Tanggal kembali wajib diisi" : null,
          ),
          const SizedBox(height: 16),

          // Denda Input
          TextFormField(
  controller: _dendaController,
  readOnly: true,
  decoration: const InputDecoration(
    labelText: "Denda (Rp)",
    prefixIcon: Icon(Icons.money_off),
  ),
),
          const SizedBox(height: 16),

          // Kondisi Mobil Dropdown
          DropdownButtonFormField<String>(
            initialValue: _kondisiMobil,
            decoration: const InputDecoration(
              labelText: "Kondisi Mobil",
              prefixIcon: Icon(Icons.build),
            ),
            items: const [
              DropdownMenuItem(value: 'Baik', child: Text('Baik')),
              DropdownMenuItem(value: 'Lecet Ringan', child: Text('Lecet Ringan')),
              DropdownMenuItem(value: 'Rusak Ringan', child: Text('Rusak Ringan')),
              DropdownMenuItem(value: 'Rusak Berat', child: Text('Rusak Berat')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _kondisiMobil = val;
                });
              }
            },
            validator: (v) => v == null ? "Kondisi mobil wajib dipilih" : null,
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
                    'tanggal_kembali': _tanggalKembali,
                    'denda': _denda,
                    'kondisi_mobil': _kondisiMobil,
                  };

                  try {
                    if (widget.pengembalian == null) {
                      await provider.addPengembalian(data);
                    } else {
                      await provider.updatePengembalian(widget.pengembalian!.id, data);
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
    _tanggalKembaliController.dispose();
    _dendaController.dispose();
    super.dispose();
  }

  Color _getMobilStatusColor(String statusRental) {
    if (statusRental.toLowerCase() == 'aktif') {
      return Colors.orange; // disewa
    }
    return Colors.green; // tersedia
  }
}
