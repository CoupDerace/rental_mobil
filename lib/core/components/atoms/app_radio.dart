import 'package:flutter/material.dart';

class AppRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Radio's groupValue/onChanged are deprecated in favor of RadioGroup.
    // Keep current behavior but ignore the deprecation for now.
    // ignore: deprecated_member_use
    return Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged);
  }
}
