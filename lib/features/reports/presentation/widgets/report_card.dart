import 'package:flutter/material.dart';

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(report["title"]),
        trailing: Text(report["value"]),
      ),
    );
  }
}
