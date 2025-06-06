import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/shared_widgets/svg_icon.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../generated/locale_keys.g.dart';

class NearbyPlacesHeader extends StatelessWidget {
  final VoidCallback? mapOnTap;

  const NearbyPlacesHeader({super.key, this.mapOnTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDouble.d16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.home_nearbyPlaces,
            style: TextStyle(
                fontSize: AppDouble.d18,
                color: ColorsManager.grey700,
                fontWeight: FontWeight.w600,

            ),
          ).tr(),
          InkWell(
            onTap: mapOnTap,
            child: Row(
              children: [
                Text(LocaleKeys.home_map,
                    style: TextStyle(
                      fontSize: 12,
                      color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.w500,
                    ))
                    .tr(),
                SizedBox(width: AppDouble.d4),
                SvgIcon(
                    color: ColorsManager.primaryColor,
                    assetName: ImageAssets.forward)
              ],
            ),
          )
        ],
      ),
    );
  }
}
