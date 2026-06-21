import 'package:flutter/material.dart';

class RememberMe extends StatelessWidget {
  const RememberMe({super.key, required this.value, required this.onChanged});

  final bool value;

  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (v) {
            onChanged(v ?? false);
          },
        ),

        const Text("Remember Me"),
      ],
    );
  }
}
