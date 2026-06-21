import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
  });

  final TextEditingController? controller;

  final String? label;

  final String? hint;

  final Widget? prefixIcon;

  final Widget? suffixIcon;

  final TextInputType? keyboardType;

  final String? Function(String?)? validator;

  final ValueChanged<String>? onChanged;

  final bool readOnly;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      onChanged: onChanged,
      readOnly: readOnly,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
