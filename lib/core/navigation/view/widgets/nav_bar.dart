import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:parki_dog/core/navigation/cubit/navigation_cubit.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';

import '../../../../features/lang/lang_cubit.dart';
import '../../../../features/lang/lang_state.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../utils/assets_manager.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(builder: (context, state) {
      return BlocBuilder<NavigationCubit, NavigationState>(
        buildWhen: (previous, current) => current is NavigationIndex,
        builder: (context, state) {
          final currentIndex = (state as NavigationIndex).index;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 70, // Fixed height similar to the image
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      context: context,
                      index: 0,
                      currentIndex: currentIndex,
                      icon: ImageAssets.homeOutlined,
                      activeIcon: ImageAssets.homeFilled,
                      label: LocaleKeys.navbar_home.tr(),
                    ),
                    _buildNavItem(
                      context: context,
                      index: 1,
                      currentIndex: currentIndex,
                      icon: ImageAssets.mapOutlined,
                      activeIcon: ImageAssets.mapFilled,
                      label: LocaleKeys.navbar_map.tr(),
                    ),
                    _buildNavItem(
                      context: context,
                      index: 2,
                      currentIndex: currentIndex,
                      icon: ImageAssets.menuOutlined,
                      activeIcon: ImageAssets.menuFilled,
                      label: LocaleKeys.navbar_menu.tr(),
                    ),
                  ],
                ),
              ),
              // Small black container at bottom
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          );
        },
      );
    });
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required String icon,
    required String activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => context.read<NavigationCubit>().changeIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isActive ? activeIcon : icon,
              height: 24, // Fixed icon size
              colorFilter: ColorFilter.mode(
                isActive ? ColorsManager.primaryColor : ColorsManager.grey300,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? ColorsManager.primaryColor : ColorsManager.grey300,
                fontSize: AppDouble.d12, // Smaller font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}