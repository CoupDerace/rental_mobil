import 'package:flutter/material.dart';

class AppProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final String? imageUrl;

  const AppProfileCard({
    super.key,
    required this.name,
    required this.role,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? Text(name.isNotEmpty ? name[0] : '?')
              : null,
        ),
        title: Text(name),
        subtitle: Text(role),
      ),
    );
  }
}
