import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_avatar.dart';
import 'package:rental_mobil/core/components/atoms/app_text.dart';

class AppProfileCard extends StatelessWidget {
  const AppProfileCard({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
  });

  final String name;
  final String email;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: AppAvatar(
          imageUrl: imageUrl,
          child: const Icon(Icons.person),
        ),
        title: AppText(
          name,
          fontWeight: FontWeight.bold,
        ),
        subtitle: AppText(email),
      ),
    );
  }
}