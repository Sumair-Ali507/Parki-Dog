import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';

class NearPlacesButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final String text;

  const NearPlacesButton({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDouble.d18),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDouble.d16, vertical: AppDouble.d8),
        decoration: ShapeDecoration(
          color: isSelected ? ColorsManager.primary200 : ColorsManager.white,
          shape: StadiumBorder(
              side: isSelected
                  ? BorderSide.none
                  : const BorderSide(
                  color: ColorsManager.grey200, width: AppDouble.d1)),
        ),
        child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: onTap == null ? Colors.grey : ColorsManager.grey700,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ).tr()),
      ),
    );
  }
}
