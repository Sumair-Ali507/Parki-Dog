import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:parki_dog/generated/locale_keys.g.dart';

class AddImageWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String imageAsset;
  final File? uploadedImage;

  const AddImageWidget({
    super.key,
    this.onTap,
    required this.imageAsset,
    this.uploadedImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: uploadedImage != null
          ? Center(
              child: CircleAvatar(
                radius: AppDouble.d43,
                backgroundColor: ColorsManager.primaryColor,
                backgroundImage: FileImage(uploadedImage!),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(imageAsset),
                const SizedBox(height: AppDouble.d8),
                Text(
                  LocaleKeys.dogOwner_addPhoto,
                  style: TextStyles.font14Grey700Medium(),
                ).tr(),
              ],
            ),
    );
  }
}
