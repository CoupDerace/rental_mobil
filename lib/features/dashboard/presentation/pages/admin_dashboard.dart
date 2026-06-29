import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_grid.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_recent_trannsaction.dart';
import '../../../../core/components/organism/app_scaffold.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();

    return AppScaffold(
      title: 'Dashboard Admin',
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => provider.loadDashboard(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardHeader(),
                    SizedBox(height: 24),
                    DashboardGrid(),
                    SizedBox(height: 24),
                    DashboardRecentTransaction(),
                  ],
                ),
              ),
            ),
    );
  }
}
