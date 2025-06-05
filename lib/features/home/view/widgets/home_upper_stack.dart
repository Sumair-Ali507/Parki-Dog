import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/text_styles.dart';
import '../../../../core/utils/values_manager.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeUpperStack extends StatelessWidget {
  final String assetName;
  final String title;
  final VoidCallback? onTapped;

  const HomeUpperStack({
    super.key,
    required this.assetName,
    required this.title,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTapped,
        borderRadius: BorderRadius.circular(AppDouble.d16),
        child: Stack(
          children: [
            SizedBox(
              height: AppDouble.d163,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDouble.d16),
                  child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          ColorsManager.black.withOpacity(AppDouble.d0_4),
                          BlendMode.darken),
                      child: SvgPicture.asset(assetName, fit: BoxFit.cover))),
            ),
            PositionedDirectional(
                start: AppDouble.d8,
                top: AppDouble.d8,
                end: AppDouble.d8,
                child: AutoSizeText(
                  title.tr(),
                  style: const TextStyle(
                    fontSize: 28,
                    color: ColorsManager.white,
                    fontWeight: FontWeight.bold
                  ),
                  maxLines: 3,
                  stepGranularity: 0.1,
                )),
          ],
        ),
      ),
    );
  }
}
