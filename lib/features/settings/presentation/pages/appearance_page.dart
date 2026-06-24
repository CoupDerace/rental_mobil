import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/theme_selector.dart';

class AppearancePage extends StatelessWidget {
  const AppearancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Tema",
      body: Padding(padding: EdgeInsets.all(20), child: ThemeSelector()),
    );
  }
}
