import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/users_provider.dart';

class UserSearch extends StatelessWidget {
  const UserSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<UsersProvider>().searchController,
      onChanged: (_) {
        context.read<UsersProvider>().refresh();
      },
      decoration: const InputDecoration(
        hintText: 'Cari user...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
