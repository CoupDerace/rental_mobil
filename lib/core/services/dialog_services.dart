import 'package:flutter/material.dart';

class DialogService {
  DialogService._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget dialog,
  }) {
    return showDialog<T>(context: context, builder: (_) => dialog);
  }

  static void close(BuildContext context) {
    Navigator.pop(context);
  }
}
