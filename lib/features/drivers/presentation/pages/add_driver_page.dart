import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/driver_form.dart';

class AddDriverPage extends StatelessWidget {
  const AddDriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Tambah Driver',
      body: Padding(padding: EdgeInsets.all(20), child: DriverForm()),
    );
  }
}
