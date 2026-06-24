import 'package:flutter/material.dart';

class SnackbarService {
  SnackbarService._();

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }

  static void showError(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message)),
    );
  }

  static void showInfo(String message) {
    messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
  }
}
