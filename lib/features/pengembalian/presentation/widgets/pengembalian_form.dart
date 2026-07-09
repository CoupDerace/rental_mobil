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
  double _dendaTerlambat = 0.0;
  double _dendaKondisi = 0.0;

  late TextEditingController _tanggalKembaliController;
  late TextEditingController _dendaController;

  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _displayDateFormat = DateFormat('dd MMM yyyy');
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  double _getConditionFine(String kondisi) {
    switch (kondisi) {
      case 'Lecet Ringan':
        return 100000.0;
      case 'Rusak Ringan':
        return 300000.0;
      case 'Rusak Berat':
        return 1000000.0;
      case 'Baik':
      default:
        return 0.0;
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedRentalId = widget.pengembalian?.rentalId;
    _tanggalKembali = widget.pengembalian?.tanggalKembali;
    _kondisiMobil = widget.pengembalian?.kondisiMobil ?? 'Baik';
    _dendaKondisi = _getConditionFine(_kondisiMobil);
    _denda = widget.pengembalian?.denda ?? 0.0;
    _dendaTerlambat = _denda - _dendaKondisi;
    if (_dendaTerlambat < 0) _dendaTerlambat = 0.0;

    _tanggalKembaliController = TextEditingController(
      text: _tanggalKembali != null ? _dateFormat.format(_tanggalKembali!) : '',
    );
    _dendaController = TextEditingController(
      text: _currencyFormat.format(_denda),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<PengembalianProvider>().fetchFormDependencies();
      if (mounted) {
        _calculateDenda();
      }
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
    final expectedDateOnly = DateTime(expectedReturnDate.year, expectedReturnDate.month, expectedReturnDate.day);
    final kembaliDateOnly = DateTime(_tanggalKembali!.year, _tanggalKembali!.month, _tanggalKembali!.day);
    final lateDays = kembaliDateOnly.difference(expectedDateOnly).inDays;

    setState(() {
      if (lateDays > 0) {
        _dendaTerlambat = (lateDays * 100000).toDouble();
      } else {
        _dendaTerlambat = 0.0;
      }
      _dendaKondisi = _getConditionFine(_kondisiMobil);
      _denda = _dendaTerlambat + _dendaKondisi;
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
                _calculateDenda();
              }
            },
            validator: (v) => v == null ? "Kondisi mobil wajib dipilih" : null,
          ),
 const SizedBox(height: 16),

// Ringkasan Biaya Card
Card(
  elevation: 0,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
    side: BorderSide(color: Theme.of(context).dividerColor),
  ),
  color: Theme.of(context).colorScheme.surface,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Biaya Pengembalian",
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const Divider(height: 24),

        Row(
          children: [
            Expanded(
              child: Text(
                "Denda Keterlambatan",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _currencyFormat.format(_dendaTerlambat),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: Text(
                "Denda Kondisi Mobil",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _currencyFormat.format(_dendaKondisi),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),

        const Divider(height: 24),

        Row(
          children: [
            Expanded(
              child: Text(
                "Total Biaya Pengembalian",
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _currencyFormat.format(_denda),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF7A1A),
                  ),
            ),
          ],
        ),
      ],
    ),
  ),
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
