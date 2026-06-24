import 'package:flutter/material.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;

  const AppBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(padding: const EdgeInsets.all(20), child: child),
    );
  }

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (_) => AppBottomSheet(child: child),
    );
  }
}
