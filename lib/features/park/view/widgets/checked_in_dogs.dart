import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/park/view/widgets/dog_tile.dart';

class CheckedInDogs extends StatelessWidget {
  const CheckedInDogs(this.dogs, {super.key});

  final List<DogModel> dogs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomIcons.bulldogLarge,
            const SizedBox(width: 8),
            Text(
              'Checked in dogs'.tr(),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              dogs.length.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dogs.length,
          itemBuilder: (context, index) {
            final dog = dogs[index];

            return DogTile(dog);
          },
        ),
      ],
    );
  }
}
