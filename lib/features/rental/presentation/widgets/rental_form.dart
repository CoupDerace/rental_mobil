import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../cars/domain/entities/car.dart';
import '../../data/models/rental_model.dart';
import '../providers/rental_provider.dart';

class RentalForm extends StatefulWidget {
  final RentalModel? rental;
  const RentalForm({super.key, this.rental});

  @override
  State<RentalForm> createState() => _RentalFormState();
}

class _RentalFormState extends State<RentalForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedPelangganId;
  String? _selectedMobilId;
  DateTime? _tanggalSewa;
  DateTime? _tanggalKembali;
  String _statusRental = 'aktif';
  double _totalBiaya = 0.0;

  late TextEditingController _tanggalSewaController;
  late TextEditingController _tanggalKembaliController;
  late TextEditingController _totalBiayaController;

  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _selectedPelangganId = widget.rental?.pelangganId;
    _selectedMobilId = widget.rental?.mobilId;
    _tanggalSewa = widget.rental?.tanggalSewa;
    _tanggalKembali = widget.rental?.tanggalKembali;
    _statusRental = widget.rental?.statusRental ?? 'aktif';
    _totalBiaya = widget.rental?.totalBiaya ?? 0.0;

    _tanggalSewaController = TextEditingController(
      text: _tanggalSewa != null ? _dateFormat.format(_tanggalSewa!) : '',
    );
    _tanggalKembaliController = TextEditingController(
      text: _tanggalKembali != null ? _dateFormat.format(_tanggalKembali!) : '',
    );
    _totalBiayaController = TextEditingController(
      text: _currencyFormat.format(_totalBiaya),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<RentalProvider>().fetchFormDependencies();
      _calculateTotalBiaya();
    });
  }

  void _calculateTotalBiaya() {
    if (_tanggalSewa == null ||
        _tanggalKembali == null ||
        _selectedMobilId == null) {
      setState(() {
        _totalBiaya = 0;
        _totalBiayaController.text = _currencyFormat.format(0);
      });
      return;
    }

    final List<Car> cars = context.read<RentalProvider>().carsList;

    final selectedCars = cars.where((c) => c.id == _selectedMobilId);

    if (selectedCars.isEmpty) {
      setState(() {
        _totalBiaya = 0;
        _totalBiayaController.text = _currencyFormat.format(0);
      });
      return;
    }

    final Car selectedCar = selectedCars.first;

    final days = _tanggalKembali!.difference(_tanggalSewa!).inDays;

    if (days <= 0) {
      setState(() {
        _totalBiaya = 0;
        _totalBiayaController.text = _currencyFormat.format(0);
      });
      return;
    }

    setState(() {
      _totalBiaya = days * selectedCar.hargaSewaPerhari;
      _totalBiayaController.text = _currencyFormat.format(_totalBiaya);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isSewa) async {
    final initialDate = isSewa
        ? (_tanggalSewa ?? DateTime.now())
        : (_tanggalKembali ?? _tanggalSewa ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isSewa) {
          _tanggalSewa = picked;
          _tanggalSewaController.text = _dateFormat.format(picked);
        } else {
          _tanggalKembali = picked;
          _tanggalKembaliController.text = _dateFormat.format(picked);
        }
      });
      _calculateTotalBiaya();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RentalProvider>();
    final availableCars = provider.getAvailableCars(widget.rental?.mobilId);

    debugPrint("cars=${availableCars.length}");
    for (final c in availableCars) {
      debugPrint("${c.id} ${c.namaMobil}");
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pelanggan Dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedPelangganId,
            decoration: const InputDecoration(
              labelText: "Pelanggan",
              prefixIcon: Icon(Icons.person),
            ),
            items: provider.pelangganList.map((p) {
              return DropdownMenuItem<String>(
                value: p.id,
                child: Text(p.nama),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedPelangganId = val;
              });
            },
            validator: (v) => v == null ? "Pelanggan wajib dipilih" : null,
          ),
          const SizedBox(height: 16),

          // Mobil Dropdown
          DropdownButtonFormField<String>(
            isExpanded: true,
            initialValue: availableCars.any((e) => e.id == _selectedMobilId)
                ? _selectedMobilId
                : null,
            decoration: const InputDecoration(
              labelText: "Mobil",
              prefixIcon: Icon(Icons.directions_car),
            ),
            items: availableCars.map((c) {
              return DropdownMenuItem<String>(
                value: c.id,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: _getStatusColor(c.statusMobil),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${c.namaMobil} (${c.platNomor})",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedMobilId = val;
              });
              _calculateTotalBiaya();
            },
            validator: (v) => v == null ? "Mobil wajib dipilih" : null,
          ),
          const SizedBox(height: 16),

          // Tanggal Sewa Picker
          TextFormField(
            controller: _tanggalSewaController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Tanggal Sewa",
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: () => _selectDate(context, true),
            validator: (v) => v == null || v.isEmpty ? "Tanggal sewa wajib diisi" : null,
          ),
          const SizedBox(height: 16),

          // Tanggal Kembali Picker
          TextFormField(
            controller: _tanggalKembaliController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Tanggal Kembali",
              prefixIcon: Icon(Icons.event),
            ),
            onTap: () => _selectDate(context, false),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return "Tanggal kembali wajib diisi";
              }
              if (_tanggalSewa != null && _tanggalKembali != null) {
                if (_tanggalKembali!.isBefore(_tanggalSewa!) ||
                    _tanggalKembali!.isAtSameMomentAs(_tanggalSewa!)) {
                  return "Tanggal kembali harus lebih besar dari tanggal sewa";
                }
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Status Rental Dropdown
          DropdownButtonFormField<String>(
            initialValue: _statusRental,
            decoration: const InputDecoration(
              labelText: "Status Rental",
              prefixIcon: Icon(Icons.info_outline),
            ),
            items: const [
              DropdownMenuItem(value: 'aktif', child: Text('Aktif')),
              DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
              DropdownMenuItem(value: 'dibatalkan', child: Text('Dibatalkan')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _statusRental = val;
                });
              }
            },
            validator: (v) => v == null ? "Status rental wajib dipilih" : null,
          ),
          const SizedBox(height: 16),

          // Total Biaya (Read Only)
          TextFormField(
            controller: _totalBiayaController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Total Biaya",
              prefixIcon: Icon(Icons.payments),
            ),
          ),
          const SizedBox(height: 24),

          // Form Actions
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
                    'pelanggan_id': _selectedPelangganId,
                    'mobil_id': _selectedMobilId,
                    'tanggal_sewa': _tanggalSewa,
                    'tanggal_kembali': _tanggalKembali,
                    'status_rental': _statusRental,
                    'total_biaya': _totalBiaya,
                  };

                  try {
                    if (widget.rental == null) {
                      await provider.addRental(data);
                    } else {
                      await provider.updateRental(widget.rental!.id, data);
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
    _tanggalSewaController.dispose();
    _tanggalKembaliController.dispose();
    _totalBiayaController.dispose();
    super.dispose();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'tersedia':
        return Colors.green;
      case 'disewa':
        return Colors.orange;
      case 'diservis':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
