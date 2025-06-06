import 'package:animated_icon_button/animated_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';

class WeightToggle extends StatelessWidget {
  WeightToggle({super.key, this.condition = '>'});

  String condition;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedIconButton(
        splashColor: Colors.transparent,
        initialIcon: condition == '>' ? 0 : 1,
        size: 24,
        icons: [
          AnimatedIconItem(
            icon: const Icon(
              CupertinoIcons.greaterthan,
              color: Colors.black,
            ),
            onPressed: () => condition = '<',
          ),
          AnimatedIconItem(
            icon: const Icon(
              CupertinoIcons.lessthan,
              color: Colors.black,
            ),
            onPressed: () => condition = '>',
          ),
        ],
      ),
    );
  }
}
