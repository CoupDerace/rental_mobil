import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const AppScaffold(
        title: "Profil",
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [ProfileHeader(), SizedBox(height: 32), ProfileMenu()],
          ),
        ),
      ),
    );
  }
}
