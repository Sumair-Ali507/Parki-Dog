import 'dart:ui';

import 'package:flutter/material.dart';

class Frost extends StatelessWidget {
  const Frost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: child,
    );
  }
}
