import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../../domain/entities/pelanggan.dart';
import '../providers/pelanggan_provider.dart';
import '../widgets/pelanggan_form.dart';

class EditPelangganPage extends StatelessWidget {
  const EditPelangganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pelanggan = ModalRoute.of(context)?.settings.arguments as Pelanggan?;

    return ChangeNotifierProvider(
      create: (_) => sl<PelangganProvider>(),
      child: AppScaffold(
        title: "Edit Pelanggan",
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: PelangganForm(pelanggan: pelanggan),
        ),
      ),
    );
  }
}
