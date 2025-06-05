import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

class CompactDogs extends StatelessWidget {
  const CompactDogs(this.dogs, {super.key});

  final List<DogModel> dogs;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: dogs.length * 20,
          height: 20,
          child: Stack(
            alignment: Alignment.centerRight,
            children: _buildStackedAvatars(),
          ),
        ),
        // const SizedBox(width: 8),
        if (dogs.isEmpty)
          Text(
            'No dogs checked in'.tr(),
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
        if (dogs.length > 3)
          Text(
            '+${dogs.length - 3} ${'other dogs'.tr()}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildStackedAvatars() {
    final List<Widget> avatars = [];

    for (var i = 0; i < dogs.length; i++) {
      if (i < 3) {
        avatars.add(
          Positioned(
            right: i * 16,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.white,
              child: Avatar(
                dogs[i].photoUrl,
                hasStatus: false,
                radius: 9,
              ),
            ),
          ),
        );
      }
    }

    return avatars;
  }
}
