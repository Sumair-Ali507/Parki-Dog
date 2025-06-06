import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parki_dog/core/extensions/extenstions.dart';
import '../../data/hard_string/how_it_works_content.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../generated/locale_keys.g.dart';
import 'our_mission_how_it_works_component.dart';

class HowWorksScreen extends StatelessWidget {
  const HowWorksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: AppDouble.d265,
                  width: double.infinity,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppDouble.d16),
                      child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              ColorsManager.black.withOpacity(AppDouble.d0_4),
                              BlendMode.darken),
                          child: SvgPicture.asset(ImageAssets.howItWorksSvg,
                              fit: BoxFit.cover))),
                ),
                Center(
                  child: Text(LocaleKeys.home_howItWorks,
                      textAlign: TextAlign.center,
                      style:TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ))
                      .tr(),
                ),
                PositionedDirectional(
                    start: AppDouble.d8,
                    top: AppDouble.d8,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                          radius: AppDouble.d20,
                          backgroundColor: ColorsManager.primary100,
                          child: SvgPicture.asset(ImageAssets.back)),
                    )),
              ],
            ),
            ...List.generate(
                howItWorksContentEnglish.length,
                    (index) => OurMissionHowItWorksComponent(
                  title: context.isEnglish
                      ? howItWorksContentEnglish[index]['title'] ?? ''
                      : howItWorksContentItalian[index]['title'] ?? '',
                  content: context.isEnglish
                      ? howItWorksContentEnglish[index]['content'] ?? ''
                      : howItWorksContentItalian[index]['content'] ?? '',
                )),
          ],
        ),
      ),
    );
  }
}
