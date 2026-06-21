import 'package:flutter/material.dart';
import 'package:rental_mobil/core/components/atoms/app_image.dart';
import 'package:rental_mobil/core/constants/asset_constansts.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 120,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return AppImage(
      path: AssetConstants.logo,
      width: size,
      height: size,
    );
  }
}