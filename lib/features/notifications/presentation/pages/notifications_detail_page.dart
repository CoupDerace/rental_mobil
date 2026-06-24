import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Detail Notifikasi",
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mobil Dikembalikan",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Text(
              "Toyota Avanza dengan nomor polisi B 1234 ABC telah dikembalikan dalam kondisi baik.",
            ),
          ],
        ),
      ),
    );
  }
}
