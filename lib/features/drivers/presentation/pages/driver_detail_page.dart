import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class DriverDetailPage extends StatelessWidget {
  const DriverDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detail Driver',
      body: Center(child: Text('Detail Driver')),
    );
  }
}
