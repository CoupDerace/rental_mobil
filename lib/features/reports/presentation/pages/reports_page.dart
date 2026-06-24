import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/components/organism/app_scaffold.dart';
import '../providers/reports_provider.dart';
import '../widgets/report_summary.dart';
import '../widgets/reports_filter.dart';
import '../widgets/request_list.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReportsProvider(),
      child: const AppScaffold(
        title: "Laporan",
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              ReportFilter(),

              SizedBox(height: 20),

              ReportSummary(),

              SizedBox(height: 20),

              ReportList(),
            ],
          ),
        ),
      ),
    );
  }
}
