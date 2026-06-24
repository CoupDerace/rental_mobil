import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/settings_provider.dart';
import '../widgets/settings_group.dart';
import '../widgets/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: AppScaffold(
        title: "Pengaturan",
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            SettingsGroup(
              title: "Tampilan",
              children: [
                SettingsItem(icon: Icons.dark_mode, title: "Tema"),

                Divider(height: 1),

                SettingsItem(icon: Icons.language, title: "Bahasa"),
              ],
            ),

            SizedBox(height: 24),

            SettingsGroup(
              title: "Keamanan",
              children: [SettingsItem(icon: Icons.security, title: "Keamanan")],
            ),

            SizedBox(height: 24),

            SettingsGroup(
              title: "Informasi",
              children: [
                SettingsItem(
                  icon: Icons.info_outline,
                  title: "Tentang Aplikasi",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
