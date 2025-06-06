import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/functions/calculate_distance.dart';
import '../../../../core/shared_widgets/rating_widget.dart';
import '../../../../core/shared_widgets/svg_icon.dart';
import '../../../../core/utils/assets_manager.dart';
import '../../../../core/utils/colors_manager.dart';
import '../../../../core/utils/values_manager.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../data/app_location.dart';

class NearbyPlacesItem extends StatelessWidget {
  final int rating;
  final int dogCount;
  final int reviewsCount;
  final AppLocation appLocation;
  final String placeName;

  const NearbyPlacesItem({
    super.key,
    required this.rating,
    required this.dogCount,
    required this.reviewsCount,
    required this.appLocation,
    required this.placeName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppDouble.d21,
          backgroundImage: AssetImage(ImageAssets.park),
        ),
        const SizedBox(width: AppDouble.d8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: .55.sw,
              child: Text(placeName,
                  style: TextStyle(

                  ),
                  maxLines: AppInt.i2,
                  overflow: TextOverflow.ellipsis),
            ),
            Row(
              children: [
                SvgIcon(
                    color: ColorsManager.grey500,
                    assetName: ImageAssets.locationPin),
                const SizedBox(width: AppDouble.d5),
                FutureBuilder(
                  future: calculateDistance(appLocation),
                  builder: (context, snapshot) => Text(
                      '${double.parse((snapshot.data ?? AppDouble.d0).toStringAsFixed(1))} km ${LocaleKeys.home_away.tr()}',
                      style: TextStyle(

                      )),
                ),
                const SizedBox(width: AppDouble.d7),
                SvgIcon(
                    color: ColorsManager.grey500,
                    assetName: ImageAssets.animalLeg),
                const SizedBox(width: AppDouble.d4),
                Text('$dogCount ${LocaleKeys.home_dogs.tr()}',
                    style: TextStyle(
                      fontSize: AppDouble.d14,
                      color: ColorsManager.grey400,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
          ],
        ),
        const Spacer(),
        Column(
          children: [
            RatingWidget(rating: rating),
            const SizedBox(height: AppDouble.d4),
            Text('($reviewsCount ${LocaleKeys.home_reviews.tr()})',
                style: TextStyle(
                  fontSize: AppDouble.d9,
                  color: ColorsManager.grey700,
                  fontWeight: FontWeight.w300,
                )),
          ],
        ),
      ],
    );
  }
}
