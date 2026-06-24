import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class CarDetailPage extends StatelessWidget {
  const CarDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Detail Mobil",
      body: Center(child: Text("Detail Mobil")),
    );
  }
}
