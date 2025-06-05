import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/theme/app_colors.dart';

class UserTypeWidget extends StatelessWidget {
  final bool isSelected;
  final String assetName;
  final String text;
  final VoidCallback? onTap;

  const UserTypeWidget({
    super.key,
    required this.isSelected,
    required this.assetName,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        // width: context.width / AppDouble.d2 - AppDouble.d34,
        // padding: const EdgeInsets.symmetric(
        //     horizontal: AppDouble.d22, vertical: AppDouble.d16),
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: isSelected ? AppColors.primary : Colors.grey, width: 2)),
        child: Column(
          children: [
            SvgPicture.asset(assetName),
            const SizedBox(height: 8),
            AutoSizeText(
              text.tr(),
              maxLines: 11,
              stepGranularity: 0.1,
              overflow: TextOverflow.ellipsis,
              // style: isSelected
              //     ? TextStyles.font16SecondarySemiBold()
              //     : TextStyles.font16NavyBlueRegular(),
            )
          ],
        ),
      ),
    );
  }
}
