import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return DropdownButton<ThemeMode>(
      value: provider.themeMode,
      isExpanded: true,
      items: const [
        DropdownMenuItem(value: ThemeMode.system, child: Text("System")),

        DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),

        DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
      ],
      onChanged: (mode) {
        provider.changeTheme(mode!);
      },
    );
  }
}
