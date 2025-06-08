import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/account/view/widgets/account_detail_tile.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';

class DogGeneralInfo extends StatelessWidget {
  DogGeneralInfo({super.key});

  final dog = GetIt.instance.get<DogModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'General Info'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            LinkButton(
              text: 'Edit'.tr(),
              onPress: () => Navigator.pushNamed(context, '/account/my-dog-info/edit-general'),
              color: AppColors.primary,
              icon: CustomIcons.edit,
            ),
          ],
        ),
        const Divider(),
        Column(
          children: [
            AccountDetailTile(icon: CustomIcons.gender, title: 'Gender'.tr(), info: dog.gender!),
            AccountDetailTile(
                icon: CustomIcons.calendarHeart,
                title: 'Date of Birth'.tr(),
                info: DateFormat.yMMMMd().format(dog.dob!)),
            AccountDetailTile(icon: CustomIcons.weight, title: 'Weight'.tr(), info: dog.weight!),
          ],
        )
      ],
    );
  }
}
