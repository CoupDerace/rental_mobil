import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/driver_provider.dart';
import '../widgets/driver_list.dart';
import '../widgets/driver_search.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DriversProvider(),
      child: AppScaffold(
        title: 'Data Driver',
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [DriverSearch(), SizedBox(height: 20), DriverList()],
        ),
      ),
    );
  }
}
