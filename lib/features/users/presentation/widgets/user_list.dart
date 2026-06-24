import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';
import 'user_card.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsersProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.filteredUsers.length,
      itemBuilder: (_, index) {
        return UserCard(user: provider.filteredUsers[index]);
      },
    );
  }
}
