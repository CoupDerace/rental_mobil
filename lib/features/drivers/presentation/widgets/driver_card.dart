import 'package:flutter/material.dart';

class DriverCard extends StatelessWidget {
  final Map<String, dynamic> driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(driver['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(driver['phone']), Text(driver['license'])],
        ),
        trailing: Chip(label: Text(driver['status'])),
      ),
    );
  }
}
