import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/karyawan.dart';
import '../providers/karyawan_provider.dart';

class KaryawanForm extends StatefulWidget {
  final KaryawanEntity? karyawan;
  const KaryawanForm({super.key, this.karyawan});

  @override
  State<KaryawanForm> createState() => _KaryawanFormState();
}

class _KaryawanFormState extends State<KaryawanForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _noHpController;
  late TextEditingController _tanggalController;
  late String _jabatan;
  late String _statusKaryawan;

  static const List<String> _jabatanOptions = ['Admin', 'Owner', 'Operator', 'OB'];
  static const List<String> _statusOptions = ['Aktif', 'Nonaktif'];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.karyawan?.namaKaryawan ?? '');
    _alamatController = TextEditingController(text: widget.karyawan?.alamat ?? '');
    _noHpController = TextEditingController(text: widget.karyawan?.noHp ?? '');
    _tanggalController = TextEditingController(
      text: widget.karyawan?.tanggalMasuk ?? '',
    );
    _jabatan = (widget.karyawan?.jabatan != null &&
            _jabatanOptions.contains(widget.karyawan!.jabatan))
        ? widget.karyawan!.jabatan
        : _jabatanOptions.first;
    _statusKaryawan = (widget.karyawan?.statusKaryawan != null &&
            _statusOptions.contains(widget.karyawan!.statusKaryawan))
        ? widget.karyawan!.statusKaryawan
        : _statusOptions.first;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _tanggalController.text.isNotEmpty
        ? DateTime.tryParse(_tanggalController.text) ?? now
        : now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _tanggalController.text =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<KaryawanProvider>();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Nama Karyawan
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(labelText: 'Nama Karyawan'),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Nama Karyawan wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          // No HP
          TextFormField(
            controller: _noHpController,
            decoration: const InputDecoration(labelText: 'Nomor HP'),
            keyboardType: TextInputType.phone,
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Nomor HP wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          // Alamat (optional)
          TextFormField(
            controller: _alamatController,
            decoration: const InputDecoration(labelText: 'Alamat'),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          // Jabatan Dropdown
          DropdownButtonFormField<String>(
            initialValue: _jabatan,
            decoration: const InputDecoration(labelText: 'Jabatan'),
            items: _jabatanOptions
                .map((j) => DropdownMenuItem(
                      value: j,
                      child: Text(j[0].toUpperCase() + j.substring(1)),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _jabatan = v);
            },
            validator: (v) =>
                v == null || v.isEmpty ? 'Jabatan wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          // Tanggal Masuk
          TextFormField(
            controller: _tanggalController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Tanggal Masuk',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _pickDate,
              ),
            ),
            onTap: _pickDate,
            validator: (v) =>
                v == null || v.isEmpty ? 'Tanggal Masuk wajib diisi' : null,
          ),
          const SizedBox(height: 12),
          // Status Karyawan Dropdown
          DropdownButtonFormField<String>(
            initialValue: _statusKaryawan,
            decoration: const InputDecoration(labelText: 'Status Karyawan'),
            items: _statusOptions
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s[0].toUpperCase() + s.substring(1)),
                    ))
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _statusKaryawan = v);
            },
            validator: (v) =>
                v == null || v.isEmpty ? 'Status Karyawan wajib diisi' : null,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final entity = KaryawanEntity(
                    id: widget.karyawan?.id ?? '',
                    namaKaryawan: _namaController.text.trim(),
                    alamat: _alamatController.text.trim(),
                    noHp: _noHpController.text.trim(),
                    jabatan: _jabatan,
                    tanggalMasuk: _tanggalController.text,
                    statusKaryawan: _statusKaryawan,
                    createdAt: widget.karyawan?.createdAt,
                  );
                  try {
                    if (widget.karyawan == null) {
                      await provider.addKaryawan(entity);
                    } else {
                      await provider.updateKaryawan(entity);
                    }
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menyimpan: $e')),
                      );
                    }
                  }
                },
                child: const Text('Simpan'),
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
    _alamatController.dispose();
    _noHpController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }
}
