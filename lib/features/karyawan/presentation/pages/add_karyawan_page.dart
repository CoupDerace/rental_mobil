import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/routes/injector.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/karyawan_provider.dart';
import '../widgets/karyawan_form.dart';

class AddKaryawanPage extends StatelessWidget {
  const AddKaryawanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<KaryawanProvider>(),
      child: AppScaffold(
        title: 'Tambah Karyawan',
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: KaryawanForm(),
        ),
      ),
    );
  }
}
