import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../providers/rental_provider.dart';
import '../widgets/rental_form.dart';

class AddRentalPage extends StatelessWidget {
  const AddRentalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<RentalProvider>(),
      child: AppScaffold(
        title: "Tambah Rental Baru",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const RentalForm(),
            ),
          ),
        ),
      ),
    );
  }
}
