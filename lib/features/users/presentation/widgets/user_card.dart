import 'package:flutter/material.dart';
import '../../domain/entities/user.dart';

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(user.nama.isNotEmpty ? user.nama[0].toUpperCase() : 'U'),
        ),
        title: Text(user.nama),
        subtitle: Text(user.email),
        trailing: Chip(
          label: Text(user.role.toUpperCase()),
        ),
      ),
    );
  }
}
