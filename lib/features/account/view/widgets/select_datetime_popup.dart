import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/extensions/extenstions.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/features/account/view/widgets/app_icon.dart';
import 'package:parki_dog/features/account/view/widgets/app_normal_dialog.dart';
import 'package:parki_dog/features/account/view/widgets/select_datetime_popup_content.dart';

Future<dynamic> selectDateTimePopup(
  BuildContext context, {
  required String title,
  String? subTitle,
  bool isDatePickerMode = true,
  DateTime? maximumDate,
  required Function(DateTime) onDateTimeChanged,
}) {
  return showAppDialog(context,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
          ).tr(),
          IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const AppIcon(
                  assetName: ImageAssets.close,
                  color: ColorsManager.iconDefault))
        ],
      ),
      content: SelectDatetimePopup(
        isDatePickerMode: isDatePickerMode,
        subTitle: subTitle,
        onDateTimeChanged: onDateTimeChanged,
        maximumDate: maximumDate,
      ));
}
