import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../data/models/service_model.dart';
import '../providers/service_provider.dart';
import '../../../cars/domain/entities/car.dart';

class ServiceForm extends StatefulWidget {
  final ServiceModel? service;
  const ServiceForm({super.key, this.service});

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedMobilId;
  DateTime? _tanggalServis;
  String _jenisServis = '';
  double _biayaServis = 0.0;
  String? _keterangan;
  String _statusServis = 'proses';

  late TextEditingController _tanggalServisController;
  late TextEditingController _biayaServisController;
  late TextEditingController _keteranganController;

  final _dateFormat = DateFormat('yyyy-MM-dd');

  final List<String> _allowedOptions = [
    'Ganti Oli',
    'Tune Up',
    'Ban',
    'Mesin',
    'Rem',
    'Kelistrikan',
    'AC',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    _selectedMobilId = widget.service?.mobilId;
    _tanggalServis = widget.service?.tanggalServis;
    _biayaServis = widget.service?.biayaServis ?? 0.0;
    _keterangan = widget.service?.keterangan;
    _statusServis = widget.service?.statusServis ?? 'proses';

    final initialJenis = widget.service?.jenisServis ?? '';
    _jenisServis = initialJenis
        .split(',')
        .map((e) => e.trim())
        .where((e) => _allowedOptions.contains(e))
        .join(',');

    _tanggalServisController = TextEditingController(
      text: _tanggalServis != null ? _dateFormat.format(_tanggalServis!) : '',
    );
    _biayaServisController = TextEditingController(
      text: _biayaServis > 0 ? _biayaServis.toStringAsFixed(0) : '',
    );
    _keteranganController = TextEditingController(
      text: _keterangan ?? '',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ServiceProvider>().fetchCars();
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalServis ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _tanggalServis = picked;
        _tanggalServisController.text = _dateFormat.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();
    final List<Car> availableCars = provider.getAvailableServiceCars(widget.service?.mobilId);

    debugPrint("=== AVAILABLE CARS ===");
    for (final c in availableCars) {
      debugPrint("${c.namaMobil}${c.statusMobil}");
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mobil Dropdown
          DropdownButtonFormField<String>(
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
                    Text("${c.namaMobil} (${c.platNomor})"),
                  ],
                ),
              );
            }).toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  _selectedMobilId = v;
                });
              }
            },
            validator: (v) => v == null ? "Mobil wajib dipilih" : null,
          ),
          const SizedBox(height: 16),

          // Tanggal Servis Picker
          TextFormField(
            controller: _tanggalServisController,
            readOnly: true,
            decoration: const InputDecoration(
              labelText: "Tanggal Servis",
              prefixIcon: Icon(Icons.date_range),
            ),
            onTap: () => _selectDate(context),
            validator: (v) => v == null || v.isEmpty ? "Tanggal servis wajib diisi" : null,
          ),
          const SizedBox(height: 16),

          // Jenis Servis Checkbox Group
          FormField<String>(
            initialValue: _jenisServis,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Jenis servis wajib dipilih";
              }
              return null;
            },
            builder: (FormFieldState<String> state) {
              final currentList = state.value != null && state.value!.isNotEmpty
                  ? state.value!.split(',').map((e) => e.trim()).toList()
                  : <String>[];

              return InputDecorator(
                decoration: InputDecoration(
                  labelText: "Jenis Servis",
                  prefixIcon: const Icon(Icons.build),
                  errorText: state.errorText,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: _allowedOptions.map((option) {
                      final isChecked = currentList.contains(option);
                      return CheckboxListTile(
                        title: Text(
                          option,
                          style: const TextStyle(fontSize: 14),
                        ),
                        value: isChecked,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        activeColor: const Color(0xFFFF7A1A),
                        onChanged: (bool? checked) {
                          final list = List<String>.from(currentList);
                          if (checked == true) {
                            if (!list.contains(option)) {
                              list.add(option);
                            }
                          } else {
                            list.remove(option);
                          }
                          list.sort((a, b) => _allowedOptions.indexOf(a).compareTo(_allowedOptions.indexOf(b)));
                          final newValue = list.join(',');
                          state.didChange(newValue);
                          setState(() {
                            _jenisServis = newValue;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Biaya Servis Input
          TextFormField(
            controller: _biayaServisController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Biaya Servis (Rp)",
              prefixIcon: Icon(Icons.attach_money),
            ),
            onChanged: (val) {
              final number = double.tryParse(val);
              if (number != null) {
                _biayaServis = number;
              }
            },
            validator: (v) {
              if (v == null || v.isEmpty) return "Biaya servis wajib diisi";
              final val = double.tryParse(v);
              if (val == null) return "Masukkan angka yang valid";
              if (val < 0) return "Biaya servis minimum 0";
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Keterangan Input (Optional)
          TextFormField(
            controller: _keteranganController,
            decoration: const InputDecoration(
              labelText: "Keterangan (Opsional)",
              prefixIcon: Icon(Icons.notes),
            ),
            minLines: 3,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 16),

          // Status Servis Dropdown
          DropdownButtonFormField<String>(
            initialValue: _statusServis,
            decoration: const InputDecoration(
              labelText: "Status Servis",
              prefixIcon: Icon(Icons.info_outline),
            ),
            items: const [
              DropdownMenuItem(value: 'proses', child: Text('Proses')),
              DropdownMenuItem(value: 'selesai', child: Text('Selesai')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  _statusServis = val;
                });
              }
            },
            validator: (v) => v == null ? "Status servis wajib dipilih" : null,
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
                    'mobil_id': _selectedMobilId,
                    'tanggal_servis': _tanggalServis,
                    'jenis_servis': _jenisServis,
                    'biaya_servis': _biayaServis,
                    'keterangan': _keteranganController.text.trim().isEmpty
                        ? null
                        : _keteranganController.text.trim(),
                    'status_servis': _statusServis,
                  };

                  try {
                    if (widget.service == null) {
                      await provider.addService(data);
                    } else {
                      await provider.updateService(widget.service!.id, data);
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
    _tanggalServisController.dispose();
    _biayaServisController.dispose();
    _keteranganController.dispose();
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
