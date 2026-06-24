import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/reports_provider.dart';

class ReportFilter extends StatelessWidget {
  const ReportFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportsProvider>();

    return DropdownButton<String>(
      value: provider.filter,
      isExpanded: true,
      items: const [
        DropdownMenuItem(value: "Harian", child: Text("Harian")),

        DropdownMenuItem(value: "Bulanan", child: Text("Bulanan")),

        DropdownMenuItem(value: "Tahunan", child: Text("Tahunan")),
      ],
      onChanged: (value) {
        provider.setFilter(value!);
      },
    );
  }
}
