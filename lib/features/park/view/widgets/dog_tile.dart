import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

class DogTile extends StatelessWidget {
  const DogTile(this.dog, {super.key});

  final DogModel dog;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 8,
      contentPadding: EdgeInsets.zero,
      leading: Avatar(dog.photoUrl, radius: 21, hasStatus: false),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Row(
                    children: [
                      Text(
                        dog.name!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary),
                      ),
                      const SizedBox(width: 4),
                      dog.gender == 'Male' ? CustomIcons.male : CustomIcons.female,
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * (dog.isSafe == false ? 0.25 : 0.6),
                child: Text(
                  dog.breed!,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: AppColors.primary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (dog.isSafe == false)
            Text(
              _getLeavingIn(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xffC70404)),
            ),
        ],
      ),
      trailing: _buildStatus(),
    );
  }

  String _getLeavingIn() {
    final leaveTime = dog.currentCheckIn!.leaveTime;
    final now = DateTime.now();

    final difference = leaveTime.difference(now);

    if (difference.inHours > 0) {
      return '${'Leaving in'.tr()} ${difference.inHours} hrs';
    }

    return '${'Leaving in'.tr()} ${difference.inMinutes} mins';
  }

  Widget? _buildStatus() {
    if (dog.id == GetIt.I.get<DogModel>().id) {
      return SizedBox(
        width: 60,
        child: Row(
          children: [
            CustomIcons.bulldogSvg,
            const SizedBox(width: 4),
            Text(
              'You'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
          ],
        ),
      );
    }

    if (dog.isSafe == true) {
      return SizedBox(
        width: 60,
        child: Row(
          children: [
            CustomIcons.safe,
            const SizedBox(width: 4),
            Text(
              'Safe'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xff06851A)),
            ),
          ],
        ),
      );
    }

    if (dog.isSafe == false) {
      return SizedBox(
        width: 70,
        child: Row(
          children: [
            CustomIcons.unsafe,
            const SizedBox(width: 4),
            Text(
              'Unsafe'.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xffC70404)),
            ),
          ],
        ),
      );
    }

    return null;
  }
}
