import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/car_form.dart';

class AddCarPage extends StatelessWidget {
  const AddCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Tambah Mobil",
      body: Padding(padding: EdgeInsets.all(20), child: CarForm()),
    );
  }
}
