import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/features/home/view/widgets/coming_soon.dart';

import '../../../../core/navigation/cubit/navigation_cubit.dart';
import '../../../auth/view/widgets/link_button.dart';
import '../../../lang/lang_cubit.dart';
import '../../../lang/lang_state.dart';

class DoggyShoppy extends StatelessWidget {
  const DoggyShoppy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Doggy Shoppy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) => LinkButton(
                  text: 'show all'.tr(),
                  color: Colors.black,
                  onPress: () {
                    context.read<NavigationCubit>().changeIndex(2);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // ComingSoon(),
        ],
      );
    });
  }
}
