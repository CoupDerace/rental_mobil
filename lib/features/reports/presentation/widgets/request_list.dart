import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports_provider.dart';
import 'report_card.dart';

class ReportList extends StatelessWidget {
  const ReportList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportsProvider>();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.reports.length,
      itemBuilder: (_, index) {
        return ReportCard(report: provider.reports[index]);
      },
    );
  }
}
