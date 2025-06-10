import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  final String assetName;
  final Color color;
  final double? size;

  const AppIcon(
      {super.key, required this.assetName, required this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      height: size,
      width: size,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}
