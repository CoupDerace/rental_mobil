import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  String name = "Administrator";
  String email = "admin@gmail.com";
  String phone = "081234567890";

  void update({
    required String newName,
    required String newEmail,
    required String newPhone,
  }) {
    name = newName;
    email = newEmail;
    phone = newPhone;

    notifyListeners();
  }
}
