import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../generated/locale_keys.g.dart';


class TellFeedBack extends StatelessWidget {
  const TellFeedBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<String> emojis = [
      ImageAssets.happyEmoji,
      ImageAssets.loveEmoji,
      ImageAssets.angryEmoji,
    ];
    return Container(
      padding: EdgeInsets.all(AppDouble.d24),
      decoration: BoxDecoration(
          color: ColorsManager.yellowLight,
          borderRadius: BorderRadius.circular(AppDouble.d24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(LocaleKeys.home_tellUs,
              style: TextStyle(
                  fontSize: AppDouble.d18,
                  color: ColorsManager.secondary400,
                  fontWeight: FontWeight.w800,

              )).tr(),
          const SizedBox(height: AppDouble.d28),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppDouble.d24,
            runSpacing: AppDouble.d24,
            children: List.generate(
                emojis.length, (index) => SvgPicture.asset(emojis[index])),
          )
        ],
      ),
    );
  }
}
