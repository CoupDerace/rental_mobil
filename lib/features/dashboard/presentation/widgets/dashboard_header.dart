import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dashboard",
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 6),

              Text(
                "Selamat datang kembali",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),

        const CircleAvatar(radius: 20, child: Icon(Icons.person)),
      ],
    );
  }
}
