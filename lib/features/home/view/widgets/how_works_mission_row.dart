import 'package:flutter/material.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../generated/locale_keys.g.dart';
import 'home_upper_stack.dart';

class HowWorksMissionRow extends StatelessWidget {
  final VoidCallback? missionOnTap;
  final VoidCallback? howWorks;

  const HowWorksMissionRow({
    super.key,
    this.missionOnTap,
    this.howWorks,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HomeUpperStack(
          assetName: ImageAssets.ourMissionSvg,
          title: LocaleKeys.home_ourMission,
          onTapped: missionOnTap,
        ),
        SizedBox(width: AppDouble.d16),
        HomeUpperStack(
          assetName: ImageAssets.howItWorksSvg,
          title: LocaleKeys.home_howItWorks,
          onTapped: howWorks,
        ),
      ],
    );
  }
}
