import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../generated/locale_keys.g.dart';

class ComingSooon extends StatelessWidget {
  const ComingSooon({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> comingSoonItems = [
      {
        "title": LocaleKeys.home_adventures,
        'image': ImageAssets.adventures,
      },
      {
        "title": LocaleKeys.home_veterinarian,
        'image': ImageAssets.veterinarian,
      },
      {
        "title": LocaleKeys.home_trainers,
        'image': ImageAssets.trainers,
      },
      {
        "title": LocaleKeys.home_washingShops,
        'image': ImageAssets.washingShops,
      },
      {
        "title": LocaleKeys.home_adoption,
        'image': ImageAssets.adoption,
      },
      {
        "title": LocaleKeys.home_lostDogs,
        'image': ImageAssets.lostDogs,
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: AppDouble.d16),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            LocaleKeys.home_comingSoon,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: AppDouble.d18,
              color: ColorsManager.secondary400,
              fontWeight: FontWeight.w600,
            ),
          ).tr(),
        ),
        const SizedBox(height: AppDouble.d16),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: AppDouble.d16,
          runSpacing: AppDouble.d16,
          children: List.generate(
              comingSoonItems.length,
              (index) => SizedBox(
                    height: AppDouble.d218,
                    width: 145,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 175,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(AppDouble.d16),
                              child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      ColorsManager.black
                                          .withOpacity(AppDouble.d0_35),
                                      BlendMode.darken),
                                  child: Image.asset(
                                      comingSoonItems[index]['image'],
                                      fit: BoxFit.cover))),
                        ),
                        Center(
                          child: Text(comingSoonItems[index]['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppDouble.d22,
                                color: ColorsManager.white,
                                fontWeight: FontWeight.bold,
                              )).tr(),
                        )
                      ],
                    ),
                  )),
        ),
        const SizedBox(height: AppDouble.d32),
      ],
    );
  }
}
