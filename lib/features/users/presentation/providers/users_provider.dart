import 'package:flutter/material.dart';

class UsersProvider extends ChangeNotifier {
  final searchController = TextEditingController();

  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'name': 'Administrator',
      'email': 'admin@gmail.com',
      'role': 'Admin',
    },
    {
      'id': 2,
      'name': 'Owner Rental',
      'email': 'owner@gmail.com',
      'role': 'Owner',
    },
    {
      'id': 3,
      'name': 'Operator',
      'email': 'operator@gmail.com',
      'role': 'Operator',
    },
  ];

  List<Map<String, dynamic>> get users => _users;

  List<Map<String, dynamic>> get filteredUsers {
    if (searchController.text.isEmpty) {
      return users;
    }

    return users.where((user) {
      return user['name'].toString().toLowerCase().contains(
        searchController.text.toLowerCase(),
      );
    }).toList();
  }

  void refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
