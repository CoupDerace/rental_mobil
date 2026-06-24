import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/user_form.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'Tambah User',
      body: Padding(padding: EdgeInsets.all(20), child: UserForm()),
    );
  }
}
