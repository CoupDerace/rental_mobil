import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(user['name'][0])),
        title: Text(user['name']),
        subtitle: Text(user['email']),
        trailing: Chip(label: Text(user['role'])),
      ),
    );
  }
}
