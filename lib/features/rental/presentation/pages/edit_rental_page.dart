import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../../data/models/rental_model.dart';
import '../providers/rental_provider.dart';
import '../widgets/rental_form.dart';

class EditRentalPage extends StatelessWidget {
  final RentalModel? rental;
  const EditRentalPage({super.key, this.rental});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<RentalProvider>(),
      child: AppScaffold(
        title: "Edit Rental",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: RentalForm(rental: rental),
            ),
          ),
        ),
      ),
    );
  }
}
