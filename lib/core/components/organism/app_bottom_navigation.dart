import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),

        NavigationDestination(icon: Icon(Icons.directions_car), label: "Mobil"),

        NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
