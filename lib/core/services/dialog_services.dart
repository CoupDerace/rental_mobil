import 'package:flutter/material.dart';

import 'navigation_service.dart';

class DialogService {
  DialogService._();

  static Future<void> showMessage({
    required String title,
    required String message,
  }) {
    final context = NavigationService.context;

    if (context == null) {
      return Future.value();
    }

    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<bool> showConfirmation({
    required String title,
    required String message,
  }) async {
    final context = NavigationService.context;

    if (context == null) {
      return false;
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }
}
