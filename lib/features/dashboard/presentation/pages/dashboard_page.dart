import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rental_mobil/shared/providers/auth_provider.dart';

import 'admin_dashboard.dart';
import 'owner_dashboard.dart';
import 'operator_dashboard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.role.toLowerCase();

    if (role == 'owner') {
      return const OwnerDashboard();
    } else if (role == 'operator') {
      return const OperatorDashboard();
    } else {
      return const AdminDashboard();
    }
  }
}
