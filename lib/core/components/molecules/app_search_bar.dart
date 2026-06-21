import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_textfield.dart';


class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.controller,
    this.hint = 'Cari...',
    this.onChanged,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hint: hint,
      prefixIcon: const Icon(Icons.search),
      onChanged: onChanged,
    );
  }
}