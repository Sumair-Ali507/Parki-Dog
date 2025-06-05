import 'package:flutter/material.dart';

import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';

class MenuContainer extends StatelessWidget {
  final Widget child;

  const MenuContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(AppDouble.d16),
        decoration: BoxDecoration(
          color: ColorsManager.grey50,
          borderRadius: BorderRadius.circular(AppDouble.d16),
        ),
        child: child);
  }
}
