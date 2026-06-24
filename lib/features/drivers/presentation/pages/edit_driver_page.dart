import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/driver_form.dart';

class EditDriverPage extends StatelessWidget {
  const EditDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Edit Driver',
      body: Padding(padding: EdgeInsets.all(20), child: DriverForm()),
    );
  }
}
