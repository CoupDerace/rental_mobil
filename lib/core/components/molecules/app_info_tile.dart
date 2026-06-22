import 'package:flutter/material.dart';

class AppInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData? icon;

  const AppInfoTile({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon == null ? null : Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
