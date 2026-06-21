import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_avatar.dart';


class AppUserAvatar extends StatelessWidget {
  const AppUserAvatar({super.key, this.photo});

  final String? photo;

  @override
  Widget build(BuildContext context) {
    return AppAvatar(imageUrl: photo, child: const Icon(Icons.person));
  }
}
