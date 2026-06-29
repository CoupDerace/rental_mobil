import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../../data/models/service_model.dart';
import '../providers/service_provider.dart';
import '../widgets/service_form.dart';

class EditServicePage extends StatelessWidget {
  final ServiceModel? service;
  const EditServicePage({super.key, this.service});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<ServiceProvider>(),
      child: AppScaffold(
        title: "Edit Servis",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ServiceForm(service: service),
            ),
          ),
        ),
      ),
    );
  }
}
