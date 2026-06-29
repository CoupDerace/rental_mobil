import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../providers/pengembalian_provider.dart';
import '../widgets/pengembalian_form.dart';

class AddPengembalianPage extends StatelessWidget {
  const AddPengembalianPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<PengembalianProvider>(),
      child: AppScaffold(
        title: "Tambah Pengembalian Baru",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: const PengembalianForm(),
            ),
          ),
        ),
      ),
    );
  }
}
