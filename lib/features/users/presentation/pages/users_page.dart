import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/users_provider.dart';
import '../widgets/user_list.dart';
import '../widgets/user_search.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UsersProvider(),
      child: AppScaffold(
        title: 'Users',
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: const [UserSearch(), SizedBox(height: 20), UserList()],
        ),
      ),
    );
  }
}
