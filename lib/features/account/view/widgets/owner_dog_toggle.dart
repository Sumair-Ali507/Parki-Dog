import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:parki_dog/features/account/cubit/toggle_dog_owner_cubit.dart';

import '../../../../generated/locale_keys.g.dart';

class OwnerDogToggle extends StatelessWidget {
  final OwnerDogCubit ownerDogCubit;

  const OwnerDogToggle({
    super.key,
    required this.ownerDogCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnerDogCubit, OwnerDogEnum>(
      bloc: ownerDogCubit,
      builder: (ownerDogContext, ownerDogState) {
        return Container(
          padding: const EdgeInsets.all(AppDouble.d8),
          margin: const EdgeInsets.symmetric(horizontal: 46),
          decoration: BoxDecoration(
              color: ColorsManager.primary100,
              borderRadius: BorderRadius.circular(AppDouble.d16),
              border:
                  Border.all(color: ColorsManager.grey50, width: AppDouble.d1)),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                      style: ownerDogState == OwnerDogEnum.owner
                          ? null
                          : ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.primary100,
                              shadowColor: Colors.transparent,
                            ),
                      onPressed: () {
                        ownerDogCubit.selectOwner();
                      },
                      child: Text(
                        LocaleKeys.profile_owner,
                        style: ownerDogState == OwnerDogEnum.owner
                            ? null
                            : TextStyles.font14Grey400SemiBold(),
                      ).tr())),
              const SizedBox(width: AppDouble.d8),
              Expanded(
                  child: ElevatedButton(
                      style: ownerDogState == OwnerDogEnum.dog
                          ? null
                          : ElevatedButton.styleFrom(
                              backgroundColor: ColorsManager.primary100,
                              shadowColor: Colors.transparent,
                            ),
                      onPressed: () {
                        ownerDogCubit.selectDog();
                      },
                      child: Text(
                        LocaleKeys.profile_dog,
                        style: ownerDogState == OwnerDogEnum.dog
                            ? null
                            : TextStyles.font14Grey400SemiBold(),
                      ).tr()))
            ],
          ),
        );
      },
    );
  }
}
