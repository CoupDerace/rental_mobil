import 'package:flutter/material.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.height = 24,
    this.thickness = 1,
  });

  final double height;
  final double thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
    );
  }
}