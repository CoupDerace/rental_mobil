import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/components/organism/app_scaffold.dart';
import '../../../../app/routes/injector.dart';
import '../../domain/entities/user.dart';
import '../providers/users_provider.dart';
import '../widgets/user_form.dart';

class EditUserPage extends StatelessWidget {
  final User? user;
  const EditUserPage({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<UsersProvider>(),
      child: AppScaffold(
        title: 'Edit User',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: UserForm(user: user),
            ),
          ),
        ),
      ),
    );
  }
}
