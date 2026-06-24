import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import 'profile_avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Column(
      children: [
        const ProfileAvatar(),

        const SizedBox(height: 16),

        Text(provider.name, style: Theme.of(context).textTheme.headlineSmall),

        Text(provider.email),
      ],
    );
  }
}
