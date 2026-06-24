import 'package:flutter/material.dart';

class BottomNavProvider extends ChangeNotifier {
  int _index = 0;

  int get index => _index;

  void change(int value) {
    _index = value;
    notifyListeners();
  }
}
