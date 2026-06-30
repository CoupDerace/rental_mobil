import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/user.dart';
import 'package:flutter/services.dart';
import '../providers/users_provider.dart';

class UserForm extends StatefulWidget {
  final User? user;
  const UserForm({super.key, this.user});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _noHpController;
  late String _selectedRole;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.user?.nama ?? '');
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _noHpController = TextEditingController(text: widget.user?.noHp ?? '');
    _selectedRole = widget.user?.role.toLowerCase() ?? 'operator';
    if (_selectedRole.isEmpty) {
      _selectedRole = 'operator';
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<UsersProvider>();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Nama input
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(labelText: "Nama"),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            validator: (v) => v == null || v.trim().isEmpty ? "Nama wajib diisi" : null,
          ),
          const SizedBox(height: 12),

          // Email input
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Email wajib diisi";
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(v.trim())) {
                return "Format email tidak valid";
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Nomor HP input
          TextFormField(
            controller: _noHpController,
            decoration: const InputDecoration(labelText: "Nomor HP"),
            keyboardType: TextInputType.phone,
            validator: (v) => v == null || v.trim().isEmpty ? "Nomor HP wajib diisi" : null,
          ),
          const SizedBox(height: 12),

          // Role dropdown
          DropdownButtonFormField<String>(
            initialValue: _selectedRole,
            decoration: const InputDecoration(labelText: "Role"),
            items: const [
              DropdownMenuItem(value: 'admin', child: Text('Admin')),
              DropdownMenuItem(value: 'owner', child: Text('Owner')),
              DropdownMenuItem(value: 'operator', child: Text('Operator')),
            ],
            onChanged: (v) {
              if (v != null) {
                setState(() {
                  _selectedRole = v;
                });
              }
            },
            validator: (v) => v == null ? "Role wajib dipilih" : null,
          ),
          const SizedBox(height: 20),

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
                  final dataMap = {
                    'nama': _namaController.text.trim(),
                    'email': _emailController.text.trim(),
                    'no_hp': _noHpController.text.trim(),
                    'role': _selectedRole,
                  };

                  try {
                    if (widget.user == null) {
                      await provider.addUser(dataMap);
                    } else {
                      await provider.updateUser(widget.user!.id, dataMap);
                    }
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(widget.user == null 
                              ? "User berhasil dibuat" 
                              : "User berhasil diperbarui"),
                        ),
                      );
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
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    super.dispose();
  }
}
