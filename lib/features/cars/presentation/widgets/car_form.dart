import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../providers/car_provider.dart';

class CarForm extends StatefulWidget {
  final Map<String, dynamic>? car;
  const CarForm({super.key, this.car});

  @override
  State<CarForm> createState() => _CarFormState();
}

class _CarFormState extends State<CarForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _tipeController;
  late TextEditingController _tahunController;
  late TextEditingController _platController;
  late TextEditingController _hargaController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.car?['nama_mobil'] ?? '');
    _tipeController = TextEditingController(text: widget.car?['tipe'] ?? '');
    _tahunController = TextEditingController(text: widget.car?['tahun']?.toString() ?? '');
    _platController = TextEditingController(text: widget.car?['plat_nomor'] ?? '');
    _hargaController = TextEditingController(text: widget.car?['harga_sewa_perhari']?.toString() ?? '');
    _statusController = TextEditingController(text: widget.car?['status_mobil'] ?? 'tersedia');
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<CarsProvider>();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(labelText: "Nama Mobil"),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            validator: (v) => v == null || v.trim().isEmpty ? "Nama Mobil wajib diisi" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _tipeController,
            decoration: const InputDecoration(labelText: "Tipe"),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            validator: (v) => v == null || v.trim().isEmpty ? "Tipe wajib diisi" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _tahunController,
            decoration: const InputDecoration(labelText: "Tahun"),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return "Tahun wajib diisi";
              if (int.tryParse(v.trim()) == null) return "Tahun harus berupa angka bulat";
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _platController,
            decoration: const InputDecoration(labelText: "Plat Nomor"),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return "Plat Nomor wajib diisi";
              final cleanVal = v.trim().toLowerCase();
              final isDuplicate = provider.cars.any((car) {
                if (widget.car != null && car.id == widget.car!['id']) {
                  return false;
                }
                return car.platNomor.toLowerCase() == cleanVal;
              });
              if (isDuplicate) return "Plat Nomor sudah terdaftar";
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _hargaController,
            decoration: const InputDecoration(labelText: "Harga Sewa per Hari"),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return "Harga wajib diisi";
              if (double.tryParse(v.trim()) == null) return "Harga harus berupa angka";
              return null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _statusController.text.toLowerCase().isEmpty ? 'tersedia' : _statusController.text.toLowerCase(),
            items: const [
              DropdownMenuItem(value: 'tersedia', child: Text('Tersedia')),
              DropdownMenuItem(value: 'disewa', child: Text('Disewa')),
              DropdownMenuItem(value: 'diservis', child: Text('Servis')),
            ],
            onChanged: (v) {
              if (v != null) {
                _statusController.text = v;
              }
            },
            decoration: const InputDecoration(labelText: "Status Mobil"),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final carMap = {
                    'nama_mobil': _namaController.text.trim(),
                    'tipe': _tipeController.text.trim(),
                    'tahun': int.tryParse(_tahunController.text.trim()) ?? 2023,
                    'plat_nomor': _platController.text.trim(),
                    'harga_sewa_perhari': double.tryParse(_hargaController.text.trim()) ?? 0.0,
                    'status_mobil': _statusController.text,
                  };
                  try {
                    if (widget.car == null) {
                      await provider.addCar(carMap);
                    } else {
                      await provider.updateCar(widget.car!['id'], carMap);
                    }
                    if (context.mounted) Navigator.pop(context);
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
    _namaController.dispose();
    _tipeController.dispose();
    _tahunController.dispose();
    _platController.dispose();
    _hargaController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}
