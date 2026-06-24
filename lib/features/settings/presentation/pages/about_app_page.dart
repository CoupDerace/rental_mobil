import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Tentang Aplikasi",
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            "Rental Mobil\nVersi 1.0.0\n\nDikembangkan menggunakan Flutter dan Supabase.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
