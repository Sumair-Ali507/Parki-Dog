import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/font_manager.dart';
import 'package:parki_dog/core/utils/styles_manager.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    //main colors
    primaryColor: ColorsManager.primaryColor,
    fontFamily: FontConstants.poppinsFontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: ColorsManager.primaryColor,
      primary: ColorsManager.primaryColor,
      secondary: ColorsManager.secondaryColor,
      onPrimary: ColorsManager.white,
      error: ColorsManager.red600,
      onError: ColorsManager.white,
      outline: ColorsManager.grey200,
    ),
    scaffoldBackgroundColor: ColorsManager.white,
    useMaterial3: true,
    //app bar theme
    appBarTheme: AppBarTheme(
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: ColorsManager.white,
            statusBarIconBrightness: Brightness.dark),
        color: ColorsManager.white,
        // shadowColor: ColorsManager.lightPrimary,
        elevation: AppDouble.d0,
        centerTitle: true,
        toolbarTextStyle: getSemiBoldStyle(
            color: ColorsManager.grey700, fontSize: FontSize.s20),
        iconTheme: const IconThemeData(color: ColorsManager.grey600),
        titleTextStyle: getSemiBoldStyle(
            color: ColorsManager.grey700, fontSize: FontSize.s20)),
    //button theme
    buttonTheme: const ButtonThemeData(
      disabledColor: ColorsManager.primary200,
      buttonColor: ColorsManager.primaryColor,
      splashColor: ColorsManager.white,
    ),
    iconTheme: const IconThemeData(
      color: ColorsManager.grey700,
    ),
    // elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: AppDouble.d12, horizontal: AppDouble.d8),
          textStyle: getSemiBoldStyle(
              color: ColorsManager.white, fontSize: FontSize.s16),
          backgroundColor: ColorsManager.primaryColor,
          foregroundColor: ColorsManager.white,
          disabledBackgroundColor: ColorsManager.primary200,
          disabledForegroundColor: ColorsManager.white,
          // fixedSize: const Size(double.infinity,55 ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDouble.d16))),
    ),
    //outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
          vertical: AppDouble.d8, horizontal: AppDouble.d16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDouble.d16)),
      side: const BorderSide(color: ColorsManager.grey200, width: AppDouble.d1),
      textStyle:
          getLightStyle(color: ColorsManager.grey600, fontSize: FontSize.s14),
      backgroundColor: ColorsManager.white,
      foregroundColor: ColorsManager.grey600,
    )),
    //Navigation bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ColorsManager.white,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: const IconThemeData(color: ColorsManager.primaryColor),
      unselectedIconTheme: const IconThemeData(color: ColorsManager.grey300),
      selectedItemColor: ColorsManager.primaryColor,
      unselectedItemColor: ColorsManager.grey300,
      selectedLabelStyle: getBoldStyle(
          color: ColorsManager.primaryColor, fontSize: FontSize.s10),
      unselectedLabelStyle:
          getRegularStyle(color: ColorsManager.grey300, fontSize: FontSize.s10),
    ),

    //popup theme
    popupMenuTheme: const PopupMenuThemeData(
        color: ColorsManager.white,
        shadowColor: ColorsManager.grey200,
        surfaceTintColor: ColorsManager.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppDouble.d16)),
        )),
    dialogBackgroundColor: ColorsManager.white,
    dialogTheme: DialogTheme(
      backgroundColor: ColorsManager.white,
      surfaceTintColor: ColorsManager.white,
      titleTextStyle: getSemiBoldStyle(
          color: ColorsManager.navyBlue, fontSize: FontSize.s18),
      shadowColor: ColorsManager.grey200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDouble.d32),
      ),
    ),
    // text theme
    // textTheme: TextTheme(
    //   displayLarge:
    //       getBoldStyle(color: ColorsManager.white, fontSize: FontSize.s36),
    //   labelLarge:
    //       getBoldStyle(color: ColorsManager.white, fontSize: FontSize.s28),
    //   bodyLarge: getBoldStyle(
    //     color: ColorsManager.white,
    //     fontSize: FontSize.s22,
    //   ),
    //   headlineLarge: getBoldStyle(
    //     color: ColorsManager.white,
    //     fontSize: FontSize.s18,
    //   ),
    //   titleLarge:
    //       getSemiBoldStyle(color: ColorsManager.white, fontSize: FontSize.s14),
    //   displayMedium: getMediumStyle(
    //     color: ColorsManager.white,
    //     fontSize: FontSize.s18,
    //   ),
    //   displaySmall:
    //       getRegularStyle(color: ColorsManager.white, fontSize: FontSize.s18),
    //   bodySmall:
    //       getRegularStyle(color: ColorsManager.white, fontSize: FontSize.s15),
    //   titleSmall: getLightStyle(
    //       color: ColorsManager.red600, fontSize: FontSize.s12),
    // ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
      textStyle: WidgetStateProperty.all(getMediumStyle(
          color: ColorsManager.primaryColor, fontSize: FontSize.s12)),
    )),
    //bottom sheet theme data
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ColorsManager.white,
      surfaceTintColor: ColorsManager.white,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppDouble.d16)),
      ),
    ),
    badgeTheme: const BadgeThemeData(
      backgroundColor: ColorsManager.redNotify,
      smallSize: AppDouble.d8,
      largeSize: AppDouble.d8,
    ),
    // input decoration theme(text form field)
    inputDecorationTheme: InputDecorationTheme(
        hintStyle: getRegularStyle(
            color: ColorsManager.grey500, fontSize: FontSize.s16),
        labelStyle: getSemiBoldStyle(
            color: ColorsManager.grey700, fontSize: FontSize.s12),
        contentPadding: const EdgeInsets.all(16),
        errorStyle: getLightStyle(
          color: ColorsManager.red600,
          fontSize: FontSize.s12,
        ),
        errorMaxLines: 3,
        helperStyle: getLightStyle(
          color: ColorsManager.green800,
          fontSize: FontSize.s12,
        ),
        prefixIconColor: ColorsManager.grey700,
        suffixIconColor: ColorsManager.grey700,
        border: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsManager.grey200, width: AppDouble.d1),
            borderRadius: BorderRadius.all(Radius.circular(AppDouble.d16))),
        disabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsManager.grey200, width: AppDouble.d1),
            borderRadius: BorderRadius.all(Radius.circular(AppDouble.d16))),
        focusedErrorBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsManager.grey200, width: AppDouble.d1),
            borderRadius: BorderRadius.all(Radius.circular(AppDouble.d16))),
        errorBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsManager.red600, width: AppDouble.d1),
            borderRadius: BorderRadius.all(Radius.circular(AppDouble.d16))),
        enabledBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsManager.grey200, width: AppDouble.d1),
            borderRadius: BorderRadius.all(Radius.circular(AppDouble.d16))),
        focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: ColorsManager.grey200, width: AppDouble.d1),
            borderRadius: BorderRadius.all(Radius.circular(AppDouble.d16)))),
  );
}
