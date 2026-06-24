import 'package:flutter/material.dart';

import 'app_app_bar.dart';
import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  final String title;

  final Widget body;

  final Widget? floatingActionButton;

  final Widget? bottomNavigationBar;

  final List<Widget>? actions;

  final Widget? drawer;

  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.actions,
    this.drawer,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppAppBar(title: title, actions: actions),

      drawer: drawer ?? const AppDrawer(name: "Administrator", role: "Admin"),

      body: SafeArea(child: body),

      floatingActionButton: floatingActionButton,

      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
