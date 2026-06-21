import 'package:flutter/material.dart';

class SnackbarService {
  SnackbarService._();

  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(String message, {Color? backgroundColor}) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  static void hide() {
    messengerKey.currentState?.hideCurrentSnackBar();
  }
}
