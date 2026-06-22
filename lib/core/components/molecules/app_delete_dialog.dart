import 'package:flutter/material.dart';

import 'app_confirm_dialog.dart';

class AppDeleteDialog extends StatelessWidget {
  final VoidCallback? onDelete;

  const AppDeleteDialog({super.key, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return AppConfirmDialog(
      title: "Hapus Data",
      message: "Apakah Anda yakin ingin menghapus data ini?",
      onConfirm: onDelete,
    );
  }
}
