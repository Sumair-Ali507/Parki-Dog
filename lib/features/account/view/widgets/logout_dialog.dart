import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parki_dog/core/extensions/extenstions.dart';
import 'package:parki_dog/core/shared_widgets/svg_icon.dart';
import 'package:parki_dog/core/utils/assets_manager.dart';
import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/text_styles.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:parki_dog/features/account/view/widgets/app_icon.dart';
import 'package:parki_dog/features/account/view/widgets/app_normal_dialog.dart';

import '../../../../generated/locale_keys.g.dart';

Future<dynamic> logoutDialog(BuildContext context) {
  return showAppDialog(
    context,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: ColorsManager.borderLightRed, width: AppDouble.d8),
          ),
          child: const CircleAvatar(
              backgroundColor: ColorsManager.red100,
              child: SvgIcon(
                  color: ColorsManager.red600, assetName: ImageAssets.logout)),
        ),
        IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const AppIcon(
                assetName: ImageAssets.close, color: ColorsManager.iconDefault))
      ],
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.profile_loggingOut,
          textAlign: TextAlign.start,
          style: TextStyles.font18NavyBlueDarkMedium(),
        ).tr(),
        const SizedBox(height: AppDouble.d4),
        Text(
          LocaleKeys.profile_sureLogOut,
          textAlign: TextAlign.start,
          style: TextStyles.font14Grey400Regular(),
        ).tr(),
        const SizedBox(height: AppDouble.d16),
        SizedBox(
          width: AppDouble.d1.sw,
          child: ElevatedButton(
              onPressed: () {
                context.pop();
              },
              child: const Text(LocaleKeys.profile_cancel).tr()),
        ),
        const SizedBox(height: AppDouble.d12),
        //   BlocProvider(
        //     create: (context) => LogoutCubit(getIt.get()),
        //     child: BlocConsumer<LogoutCubit, LogoutState>(
        //       listener: (logoutContext, logoutState) {
        //         if (logoutState.isError) {
        //           showTopSnackBar(context,
        //               message: logoutState.error.tr(), isGreen: false);
        //         }
        //         if (logoutState.isSuccess) {
        //           showTopSnackBar(context,
        //               message:
        //                   LocaleKeys.profile_profileLoggedOutSuccessfully.tr(),
        //               isGreen: true);
        //           context.pushNamedAndRemoveUntil(Routes.loginRoute,
        //               predicate: (context) => false);
        //         }
        //       },
        //       builder: (logoutContext, logoutState) {
        //         LogoutCubit logoutCubit = logoutContext.read<LogoutCubit>();
        //         return logoutState.isLoading
        //             ? const Center(child: CircularProgressIndicator())
        //             : SizedBox(
        //                 width: double.infinity,
        //                 child: TextButton(
        //                   onPressed: () {
        //                     logoutCubit.logout();
        //                   },
        //                   child: Text(LocaleKeys.profile_logout,
        //                           style: TextStyles.font16Red600Medium())
        //                       .tr(),
        //                 ),
        //               );
        //       },
        //     ),
        //   ),
      ],
    ),
  );
}
