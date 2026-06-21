import 'package:flutter/material.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.title,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: title == null ? null : Text(title!),
      contentPadding: EdgeInsets.zero,
    );
  }
}