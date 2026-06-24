import 'package:flutter/material.dart';

import '../../../../core/components/organism/app_scaffold.dart';

class ReportDetailPage extends StatelessWidget {
  const ReportDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: "Detail Laporan",
      body: Center(child: Text("Detail Laporan")),
    );
  }
}
