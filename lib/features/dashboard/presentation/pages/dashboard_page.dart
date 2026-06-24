import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/features/dashboard/presentation/widgets/dashboard_recent_trannsaction.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_grid.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_quick_menu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: AppScaffold(
        title: "Dashboard",
        body: RefreshIndicator(
          onRefresh: () => context.read<DashboardProvider>().refresh(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              DashboardHeader(),

              SizedBox(height: 24),

              DashboardGrid(),

              SizedBox(height: 24),

              DashboardQuickMenu(),

              SizedBox(height: 24),

              DashboardRecentTransaction(),
            ],
          ),
        ),
      ),
    );
  }
}
