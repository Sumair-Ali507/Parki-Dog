import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double height;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index < currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            height: height,
            decoration: BoxDecoration(
              color: isActive ? AppColors.primary : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
