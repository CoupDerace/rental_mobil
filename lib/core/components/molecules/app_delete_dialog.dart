import 'package:flutter/material.dart';

import 'app_confirm_dialog.dart';

class AppDeleteDialog extends StatelessWidget {
  const AppDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppConfirmDialog(
      title: 'Hapus Data',
      message: 'Apakah Anda yakin ingin menghapus data ini?',
    );
  }
}
