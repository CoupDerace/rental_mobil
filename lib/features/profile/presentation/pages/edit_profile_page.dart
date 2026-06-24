import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../widgets/profile_form.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Edit Profil",
      body: Padding(padding: EdgeInsets.all(20), child: ProfileForm()),
    );
  }
}
