import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:parki_dog/core/theme/app_colors.dart';
import 'package:parki_dog/features/auth/cubit/auth_cubit.dart';
import 'package:parki_dog/features/auth/data/dog_model.dart';
import 'package:parki_dog/features/home/view/widgets/avatar.dart';

import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class Greeting extends StatelessWidget {
  const Greeting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                return Avatar(
                  GetIt.instance.get<DogModel>().photoUrl,
                  radius: 30,
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthCubit, AuthState>(
                buildWhen: (previous, current) => current is AccountDataChanged,
                builder: (context, state) {
                  return Text(
                    '${'Hey'.tr()} ${GetIt.instance.get<DogModel>().name!}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                "Let's find you a park!".tr(),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: AppColors.primary),
              ),
            ],
          )
        ],
      );
    });
  }
}
