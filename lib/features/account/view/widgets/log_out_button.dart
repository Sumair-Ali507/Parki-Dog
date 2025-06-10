

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/values_manager.dart';

import '../../../../core/shared_widgets/svg_icon.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../../generated/locale_keys.g.dart';

class LogOutButton extends StatelessWidget {
  final VoidCallback? onTap;
  const LogOutButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDouble.d16),
      child: Container(
        padding: const EdgeInsets.all(AppDouble.d16),
        decoration: BoxDecoration(
          color: ColorsManager.red50,
          borderRadius: BorderRadius.circular(AppDouble.d16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SvgIcon(
                color: ColorsManager.red600, assetName: ImageAssets.logout),
            const SizedBox(width: AppDouble.d12),
            Text(
              LocaleKeys.profile_logout,
              textAlign: TextAlign.center,
              style: TextStyles.font16Red600SemiBold(),
            ).tr()
          ],
        ),
      ),
    );
  }
}
