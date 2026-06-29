import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';
import '../../domain/entities/pelanggan.dart';
import '../providers/pelanggan_provider.dart';

class PelangganForm extends StatefulWidget {
  final Pelanggan? pelanggan;
  const PelangganForm({super.key, this.pelanggan});

  @override
  State<PelangganForm> createState() => _PelangganFormState();
}

class _PelangganFormState extends State<PelangganForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _alamatController;
  late TextEditingController _noHpController;
  late TextEditingController _noIdentitasController;
  late String _jenisIdentitas;

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? _fotoIdentitasUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.pelanggan?.nama ?? '');
    _alamatController = TextEditingController(text: widget.pelanggan?.alamat ?? '');
    _noHpController = TextEditingController(text: widget.pelanggan?.noHp ?? '');
    _noIdentitasController = TextEditingController(text: widget.pelanggan?.noIdentitas ?? '');
    _jenisIdentitas = widget.pelanggan?.jenisIdentitas ?? 'KTP';
    _fotoIdentitasUrl = widget.pelanggan?.fotoIdentitas;
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<PelangganProvider>();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(labelText: "Nama Pelanggan"),
            validator: (v) => v == null || v.trim().isEmpty ? "Nama wajib diisi" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _noHpController,
            decoration: const InputDecoration(labelText: "Nomor HP"),
            keyboardType: TextInputType.phone,
            validator: (v) => v == null || v.trim().isEmpty ? "Nomor HP wajib diisi" : null,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _jenisIdentitas,
            items: const [
              DropdownMenuItem(value: 'KTP', child: Text('KTP')),
              DropdownMenuItem(value: 'SIM', child: Text('SIM')),
              DropdownMenuItem(value: 'Passport', child: Text('Passport')),
              DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
            ],
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  _jenisIdentitas = v;
                });
              }
            },
            decoration: const InputDecoration(labelText: "Jenis Identitas"),
            validator: (v) => v == null || v.trim().isEmpty ? "Jenis Identitas wajib diisi" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _noIdentitasController,
            decoration: const InputDecoration(labelText: "Nomor Identitas"),
            validator: (v) => v == null || v.trim().isEmpty ? "Nomor Identitas wajib diisi" : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _alamatController,
            decoration: const InputDecoration(labelText: "Alamat "),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          // Foto Identitas UI
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Foto Identitas",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_imageFile == null && (_fotoIdentitasUrl == null || _fotoIdentitasUrl!.isEmpty))
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade700),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.image_not_supported, color: Colors.grey),
                      SizedBox(width: 8),
                      Text("Belum Upload", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              else
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imageFile != null
                        ? Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            _fotoIdentitasUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Text("Gagal memuat gambar"));
                            },
                          ),
                  ),
                ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: _isUploading ? null : _pickImage,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  (_imageFile == null && (_fotoIdentitasUrl == null || _fotoIdentitasUrl!.isEmpty))
                      ? "Pilih Foto"
                      : "Ganti Foto",
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isUploading ? null : () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _isUploading ? null : () async {
                  if (!_formKey.currentState!.validate()) return;
                  
                  setState(() {
                    _isUploading = true;
                  });

                  String? uploadedUrl = _fotoIdentitasUrl;

                  try {
                    if (_imageFile != null) {
                      // 1. Upload new image
                      final fileBytes = await _imageFile!.readAsBytes();
                      final fileExt = _imageFile!.name.split('.').last;
                      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';

                      await SupabaseService.client.storage.from('identitas').uploadBinary(
                        fileName,
                        fileBytes,
                        fileOptions: const FileOptions(contentType: 'image/*', upsert: true),
                      );

                      uploadedUrl = SupabaseService.client.storage.from('identitas').getPublicUrl(fileName);

                      // 2. Delete old image from storage if we had one
                      if (_fotoIdentitasUrl != null && _fotoIdentitasUrl!.isNotEmpty) {
                        try {
                          final uri = Uri.parse(_fotoIdentitasUrl!);
                          final oldFileName = uri.pathSegments.last;
                          await SupabaseService.client.storage.from('identitas').remove([oldFileName]);
                        } catch (e) {
                          debugPrint("Error removing old image: $e");
                        }
                      }
                    }

                    final dataMap = {
                      'nama': _namaController.text.trim(),
                      'no_hp': _noHpController.text.trim(),
                      'alamat': _alamatController.text.trim().isEmpty
                          ? null
                          : _alamatController.text.trim(),
                      'jenis_identitas': _jenisIdentitas,
                      'no_identitas': _noIdentitasController.text.trim(),
                      'foto_identitas': uploadedUrl,
                    };

                    if (widget.pelanggan == null) {
                      await provider.addPelanggan(dataMap);
                    } else {
                      await provider.updatePelanggan(widget.pelanggan!.id, dataMap);
                    }
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal menyimpan data: $e")),
                      );
                    }
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isUploading = false;
                      });
                    }
                  }
                },
                child: _isUploading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text("Simpan"),
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
    _noIdentitasController.dispose();
    super.dispose();
  }
}
