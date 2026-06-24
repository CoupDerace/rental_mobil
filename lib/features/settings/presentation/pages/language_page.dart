import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/language_selector.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Bahasa",
      body: Padding(padding: EdgeInsets.all(20), child: LanguageSelector()),
    );
  }
}
