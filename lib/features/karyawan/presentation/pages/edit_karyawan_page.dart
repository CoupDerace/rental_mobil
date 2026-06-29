import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/injector.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../domain/entities/karyawan.dart';
import '../providers/karyawan_provider.dart';
import '../widgets/karyawan_form.dart';

class EditKaryawanPage extends StatelessWidget {
  final KaryawanEntity karyawan;
  const EditKaryawanPage({super.key, required this.karyawan});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<KaryawanProvider>(),
      child: AppScaffold(
        title: 'Edit Karyawan',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: KaryawanForm(karyawan: karyawan),
        ),
      ),
    );
  }
}
