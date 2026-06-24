import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class ServiceDetailPage extends StatelessWidget {
  const ServiceDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detail Servis',
      body: Center(child: Text('Detail Servis')),
    );
  }
}
