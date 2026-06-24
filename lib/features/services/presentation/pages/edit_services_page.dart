import 'package:flutter/material.dart';
import 'package:rental_mobil/features/services/presentation/widgets/services_form.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class EditServicePage extends StatelessWidget {
  const EditServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Edit Servis',
      body: Padding(padding: EdgeInsets.all(20), child: ServiceForm()),
    );
  }
}
