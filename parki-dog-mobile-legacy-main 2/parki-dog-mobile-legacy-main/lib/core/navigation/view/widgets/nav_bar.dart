import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/core/theme/icons/custom_icons.dart';
import 'package:parki_dog/core/widgets/frost.dart';

import '../../../../features/lang/lang_cubit.dart';
import '../../../../features/lang/lang_state.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return BlocBuilder<NavigationCubit, NavigationState>(
        buildWhen: (previous, current) => current is NavigationIndex,
        builder: (context, state) {
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            child: Frost(
              child: BottomNavigationBar(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  elevation: 0,
                  selectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  iconSize: 24,
                  unselectedLabelStyle: const TextStyle(
                    color: Color(0xffa3a3a3),
                    fontWeight: FontWeight.w400,
                  ),
                  onTap: (value) => context.read<NavigationCubit>().changeIndex(value),
                  currentIndex: (state as NavigationIndex).index,
                  items: [
                    BottomNavigationBarItem(
                      icon: CustomIcons.homeInactive,
                      activeIcon: CustomIcons.home,
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: CustomIcons.locationInactive,
                      activeIcon: CustomIcons.location,
                      label: 'Map',
                    ),
                    BottomNavigationBarItem(
                        icon: CustomIcons.cart, activeIcon: CustomIcons.cartActive, label: 'Shop'.tr()),
                  ]),
            ),
          );
        },
      );
    });
  }
}
