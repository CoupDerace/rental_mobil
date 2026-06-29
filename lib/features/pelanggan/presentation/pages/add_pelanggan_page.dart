import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../providers/pelanggan_provider.dart';
import '../widgets/pelanggan_form.dart';

class AddPelangganPage extends StatelessWidget {
  const AddPelangganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<PelangganProvider>(),
      child: const AppScaffold(
        title: "Tambah Pelanggan",
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: PelangganForm(),
        ),
      ),
    );
  }
}
