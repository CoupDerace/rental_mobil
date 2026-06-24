import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.directions_car)),
        title: Text("${car['brand']} ${car['model']}"),
        subtitle: Text("${car['plate']} • ${car['year']}"),
        trailing: Chip(label: Text(car['status'])),
      ),
    );
  }
}
