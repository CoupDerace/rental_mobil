import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Tentang",
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            FlutterLogo(size: 100),

            SizedBox(height: 20),

            Text(
              "Rental Mobil",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text("Versi 1.0.0"),

            SizedBox(height: 20),

            Text(
              "Aplikasi manajemen rental mobil berbasis Flutter dan Supabase.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
