import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> service;

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.build)),
        title: Text(service['vehicle']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service['plate']),
            Text(service['service']),
            Text(service['date']),
          ],
        ),
        trailing: Chip(label: Text(service['status'])),
      ),
    );
  }
}
