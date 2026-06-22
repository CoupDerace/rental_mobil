import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;
  final String initials;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.radius = 20,
    this.initials = '',
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl!),
      );
    }

    return CircleAvatar(radius: radius, child: Text(initials));
  }
}
