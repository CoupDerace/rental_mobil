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
    return Radio<T>(value: value, groupValue: groupValue, onChanged: onChanged);
  }
}
