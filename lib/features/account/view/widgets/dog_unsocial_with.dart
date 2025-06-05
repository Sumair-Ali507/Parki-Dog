import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/account/view/widgets/account_detail_tile.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/auth/view/widgets/link_button.dart';

class DogUnsocialWith extends StatelessWidget {
  DogUnsocialWith({super.key});

  final dog = GetIt.instance.get<DogModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Unsocial With'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            LinkButton(
              text: 'Edit'.tr(),
              onPress: () => Navigator.pushNamed(context, '/account/my-dog-info/edit-sociability'),
              color: AppColors.primary,
              icon: CustomIcons.edit,
            ),
          ],
        ),
        const Divider(),
        Column(
          children: [
            AccountDetailTile(
                icon: CustomIcons.paw,
                title: 'Breeds'.tr(),
                info: dog.unsocialWith!.breeds.isEmpty ? '-' : dog.unsocialWith!.breeds.join(', ')),
            AccountDetailTile(
                icon: CustomIcons.gender,
                title: 'Gender(s)'.tr(),
                info: dog.unsocialWith!.gender.isEmpty ? '-' : dog.unsocialWith!.gender.join(', ')),
            AccountDetailTile(
                icon: CustomIcons.weight,
                title: 'Weights'.tr(),
                info: dog.unsocialWith!.weight == null
                    ? '-'
                    : '${dog.unsocialWith!.weightCondition} ${dog.unsocialWith!.weight} kg'),
          ],
        )
      ],
    );
  }
}
