import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Detail User',
      body: Center(child: Text('Detail User')),
    );
  }
}
