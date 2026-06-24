import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/settings_provider.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: Consumer<SettingsProvider>(
        builder: (_, provider, __) {
          return AppScaffold(
            title: "Keamanan",
            body: SwitchListTile(
              title: const Text("Login Biometrik"),
              value: provider.biometric,
              onChanged: provider.enableBiometric,
            ),
          );
        },
      ),
    );
  }
}
