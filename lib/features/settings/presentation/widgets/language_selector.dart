import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();

    return DropdownButton<String>(
      value: provider.language,
      isExpanded: true,
      items: const [
        DropdownMenuItem(value: "Indonesia", child: Text("Indonesia")),

        DropdownMenuItem(value: "English", child: Text("English")),
      ],
      onChanged: (value) {
        provider.changeLanguage(value!);
      },
    );
  }
}
