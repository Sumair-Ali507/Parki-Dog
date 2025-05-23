import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../generated/locale_keys.g.dart';
import '../../../utils/assets_manager.dart';
import '../../../utils/colors_manager.dart';
import '../../../utils/values_manager.dart';
import '../../cubit/bottom_navigation_bar_cubit.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int screenIndex;
  final double radius = AppDouble.d20;
  final List<BoxShadow>? boxShadow;

  const BottomNavigationBarWidget({
    super.key,
    required this.screenIndex,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: screenIndex,
      useLegacyColorScheme: false,
      items: [
        BottomNavigationBarItem(
          icon: screenIndex == AppInt.i0
              ? SvgPicture.asset(
            ImageAssets.homeFilled,
            colorFilter: ColorFilter.mode(
                ColorsManager.primaryColor, BlendMode.srcIn),
          )
              : SvgPicture.asset(
            ImageAssets.homeOutlined,
            colorFilter: const ColorFilter.mode(
                ColorsManager.grey300, BlendMode.srcIn),
          ),
          label: LocaleKeys.navbar_home.tr(),
        ),
        BottomNavigationBarItem(
            icon: screenIndex == AppInt.i1
                ? SvgPicture.asset(
              ImageAssets.mapFilled,
              colorFilter: const ColorFilter.mode(
                  ColorsManager.primaryColor, BlendMode.srcIn),
            )
                : SvgPicture.asset(
              ImageAssets.mapOutlined,
              colorFilter: const ColorFilter.mode(
                  ColorsManager.grey300, BlendMode.srcIn),
            ),
            label: LocaleKeys.navbar_map.tr()),
        // BottomNavigationBarItem(
        //     icon: screenIndex == AppInt.i2
        //         ? SvgPicture.asset(
        //             ImageAssets.activityFilled,
        //             colorFilter: const ColorFilter.mode(
        //                 ColorsManager.primaryColor, BlendMode.srcIn),
        //           )
        //         : SvgPicture.asset(
        //             ImageAssets.activityOutlined,
        //             colorFilter: const ColorFilter.mode(
        //                 ColorsManager.grey300, BlendMode.srcIn),
        //           ),
        //     label: LocaleKeys.navbar_activities.tr()),
        // BottomNavigationBarItem(
        //     icon: screenIndex == AppInt.i3
        //         ? SvgPicture.asset(
        //             ImageAssets.shopFilled,
        //             colorFilter: const ColorFilter.mode(
        //                 ColorsManager.primaryColor, BlendMode.srcIn),
        //           )
        //         : SvgPicture.asset(
        //             ImageAssets.shoppingOutlinedSvg,
        //             colorFilter: const ColorFilter.mode(
        //                 ColorsManager.grey300, BlendMode.srcIn),
        //           ),
        //     label: LocaleKeys.navbar_shop.tr()),
        BottomNavigationBarItem(
            icon: screenIndex == AppInt.i2
                ? SvgPicture.asset(
              ImageAssets.menuFilled,
              colorFilter: const ColorFilter.mode(
                  ColorsManager.primaryColor, BlendMode.srcIn),
            )
                : SvgPicture.asset(
              ImageAssets.menuOutlined,
              colorFilter: const ColorFilter.mode(
                  ColorsManager.grey300, BlendMode.srcIn),
            ),
            label: LocaleKeys.navbar_menu.tr()),
      ],
      onTap: (index) {
        // print(index);
        context.read<BottomNavigationCubit>().changeScreen(index);
      },
    );
  }
}
