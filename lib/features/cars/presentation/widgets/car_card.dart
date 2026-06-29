import 'package:flutter/material.dart';
import '../../domain/entities/car.dart';
import 'status_badge.dart';

class CarCard extends StatelessWidget {
  final Car car;

  const CarCard({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E2A44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.white10),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0x1AFF7A1A),
          child: Icon(Icons.directions_car, color: Color(0xFFFF7A1A)),
        ),
        title: Text(car.namaMobil, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(
          "${car.platNomor} • ${car.tipe}",
          style: const TextStyle(color: Color(0xFF94A3B8)),
        ),
        trailing: StatusBadge(status: car.statusMobil),
      ),
    );
  }
}
