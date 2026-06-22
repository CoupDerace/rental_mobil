import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final String? label;
  final TextInputType? keyboardType;
  final bool enabled;
  final int maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.keyboardType,
    this.enabled = true,
    this.maxLines = 1,
    this.prefix,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
      ),
    );
  }
}
