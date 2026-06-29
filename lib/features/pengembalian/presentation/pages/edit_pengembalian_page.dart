import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../../data/models/pengembalian_model.dart';
import '../providers/pengembalian_provider.dart';
import '../widgets/pengembalian_form.dart';

class EditPengembalianPage extends StatelessWidget {
  final PengembalianModel? pengembalian;
  const EditPengembalianPage({super.key, this.pengembalian});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<PengembalianProvider>(),
      child: AppScaffold(
        title: "Edit Pengembalian",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: PengembalianForm(pengembalian: pengembalian),
            ),
          ),
        ),
      ),
    );
  }
}
