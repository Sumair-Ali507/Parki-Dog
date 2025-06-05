import 'package:flutter/material.dart';
import 'package:parki_dog/core/shared_widgets/svg_icon.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/values_manager.dart';

class RatingWidget extends StatelessWidget {
  final int rating;

  const RatingWidget({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(AppInt.i5, (index) {
        return SvgIcon(
          assetName: index < rating
              ? ImageAssets.boneFilled
              : ImageAssets.boneOutlined,
          color: index < rating
              ? ColorsManager.secondary200
              : ColorsManager.grey400,
        );
      }),
    );
  }
}
