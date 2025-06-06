import 'package:parki_dog/core/utils/colors_manager.dart';
import 'package:parki_dog/core/utils/font_manager.dart';
import 'package:parki_dog/core/utils/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:parki_dog/core/utils/values_manager.dart';

class TextStyles {
  //bold
  static TextStyle font40WhiteBold(
      {double size = FontSize.s40, Color color = ColorsManager.white}) {
    return getBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font28WhiteBold(
      {double size = FontSize.s28, Color color = ColorsManager.white}) {
    return getBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font22WhiteBold(
      {double size = FontSize.s22, Color color = ColorsManager.white}) {
    return getBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font18BlackBold(
      {double size = FontSize.s18, Color color = ColorsManager.black}) {
    return getBoldStyle(color: color, fontSize: size);
  }

  //semi bold
  static TextStyle font24Grey600SemiBold(
      {double size = FontSize.s24, Color color = ColorsManager.grey600}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font24Grey700SemiBold(
      {double size = FontSize.s24, Color color = ColorsManager.grey700}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font18NavyBlueSemiBold(
      {double size = FontSize.s18, Color color = ColorsManager.navyBlue}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font18NavyBlueDarkSemiBold(
      {double size = FontSize.s18, Color color = ColorsManager.navyBlueDark}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font18Grey600SemiBoldRoboto(
      {double size = FontSize.s18, Color color = ColorsManager.grey600}) {
    return getSemiBoldStyle(
        color: color,
        fontSize: size,
        fontFamily: FontConstants.robotoFontFamily);
  }

  static TextStyle font18Grey700SemiBold(
      {double size = FontSize.s18, Color color = ColorsManager.grey700}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font18AppBlackSemiBold(
      {double size = FontSize.s18, Color color = ColorsManager.appBlack}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font18Secondary400SemiBold(
      {double size = FontSize.s18, Color color = ColorsManager.secondary400}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font18Secondary700SemiBold(
      {double size = FontSize.s18, Color color = ColorsManager.secondary700}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font16SecondarySemiBold(
      {double size = FontSize.s16,
      Color color = ColorsManager.secondaryColor}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font16Red600SemiBold(
      {double size = FontSize.s16, Color color = ColorsManager.red600}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font16Primary600SemiBold(
      {double size = FontSize.s16, Color color = ColorsManager.primary600}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey600SemiBold(
      {double size = FontSize.s16, Color color = ColorsManager.grey600}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey700SemiBold(
      {double size = FontSize.s16, Color color = ColorsManager.grey700}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font14Grey400SemiBold(
      {double size = FontSize.s14, Color color = ColorsManager.grey400}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font14Grey600SemiBold(
      {double size = FontSize.s14, Color color = ColorsManager.grey600}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font12Green800SemiBold(
      {double size = FontSize.s12, Color color = ColorsManager.green800}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font12Grey600SemiBold(
      {double size = FontSize.s12, Color color = ColorsManager.grey600}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  static TextStyle font12Grey600SemiBoldUnderline(
      {double size = FontSize.s12,
      Color color = ColorsManager.grey600,
      TextDecoration decoration = TextDecoration.underline}) {
    return getSemiBoldStyle(
        color: color, fontSize: size, decoration: decoration);
  }

  static TextStyle font12RedDarkSemiBold(
      {double size = FontSize.s12, Color color = ColorsManager.redDark}) {
    return getSemiBoldStyle(color: color, fontSize: size);
  }

  //medium
  static TextStyle font40PrimaryMedium(
      {double size = FontSize.s40, Color color = ColorsManager.primaryColor}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font20Grey700Medium(
      {double size = FontSize.s20, Color color = ColorsManager.grey700}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font20Red600Medium(
      {double size = FontSize.s20, Color color = ColorsManager.red600}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font18Grey600Medium(
      {double size = FontSize.s18, Color color = ColorsManager.grey600}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font18NavyBlueDarkMedium(
      {double size = FontSize.s18, Color color = ColorsManager.navyBlueDark}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey700MediumRoboto(
      {double size = FontSize.s16, Color color = ColorsManager.grey700}) {
    return getMediumStyle(
        color: color,
        fontSize: size,
        fontFamily: FontConstants.robotoFontFamily);
  }

  static TextStyle font16Grey600Medium(
      {double size = FontSize.s16, Color color = ColorsManager.grey600}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font16Red600Medium(
      {double size = FontSize.s16, Color color = ColorsManager.red600}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey700Medium(
      {double size = FontSize.s16, Color color = ColorsManager.grey700}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font16WhiteMedium(
      {double size = FontSize.s16, Color color = ColorsManager.white}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font16PrimaryMedium(
      {double size = FontSize.s16, Color color = ColorsManager.primaryColor}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font16Green800MediumRoboto(
      {double size = FontSize.s16, Color color = ColorsManager.green800}) {
    return getMediumStyle(
        color: color,
        fontSize: size,
        fontFamily: FontConstants.robotoFontFamily);
  }

  static TextStyle font14Grey700Medium(
      {double size = FontSize.s14, Color color = ColorsManager.grey700}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font14Grey600Medium(
      {double size = FontSize.s14, Color color = ColorsManager.grey600}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font14Grey500Medium(
      {double size = FontSize.s14, Color color = ColorsManager.grey500}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font14Grey400Medium(
      {double size = FontSize.s14, Color color = ColorsManager.grey400}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font14BlackMedium(
      {double size = FontSize.s14, Color color = ColorsManager.black}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font14WhiteMedium(
      {double size = FontSize.s14, Color color = ColorsManager.white}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font12PrimaryMedium(
      {double size = FontSize.s12, Color color = ColorsManager.primaryColor}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font12Grey500Medium(
      {double size = FontSize.s12, Color color = ColorsManager.grey500}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font12Green800Medium(
      {double size = FontSize.s12, Color color = ColorsManager.green800}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font10Grey700Medium(
      {double size = FontSize.s10, Color color = ColorsManager.grey700}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  static TextStyle font9Primary600Medium(
      {double size = FontSize.s9, Color color = ColorsManager.primary600}) {
    return getMediumStyle(color: color, fontSize: size);
  }

  //regular
  static TextStyle font24GreyDarkRegular(
      {double size = FontSize.s24, Color color = ColorsManager.greyDark}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font16NavyBlueRegular(
      {double size = FontSize.s16, Color color = ColorsManager.navyBlue}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey400Regular(
      {double size = FontSize.s16, Color color = ColorsManager.grey400}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey500Regular(
      {double size = FontSize.s16, Color color = ColorsManager.grey500}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey600Regular(
      {double size = FontSize.s16, Color color = ColorsManager.grey600}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font16Grey700Regular(
      {double size = FontSize.s16, Color color = ColorsManager.grey700}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font14PrimaryUnderLineRegular(
      {double size = FontSize.s14, Color color = ColorsManager.primaryColor}) {
    return getRegularStyle(
        color: color, fontSize: size, decoration: TextDecoration.underline);
  }

  static TextStyle font14RedIconRegular(
      {double size = FontSize.s14, Color color = ColorsManager.redIcon}) {
    return getRegularStyle(
      color: color,
      fontSize: size,
    );
  }

  static TextStyle font14AppBlackRegular(
      {double size = FontSize.s14, Color color = ColorsManager.appBlack}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font14BlackRegular(
      {double size = FontSize.s14, Color color = ColorsManager.black}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font14Black94Regular({double size = FontSize.s14}) {
    return getRegularStyle(
        color: ColorsManager.black.withOpacity(AppDouble.d0_94),
        fontSize: size);
  }

  static TextStyle font14Grey400Regular(
      {double size = FontSize.s14, Color color = ColorsManager.grey400}) {
    return getRegularStyle(
      color: color,
      fontSize: size,
    );
  }

  static TextStyle font14Grey500Regular(
      {double size = FontSize.s14, Color color = ColorsManager.grey500}) {
    return getRegularStyle(
      color: color,
      fontSize: size,
    );
  }

  static TextStyle font14Grey600Regular(
      {double size = FontSize.s14, Color color = ColorsManager.grey600}) {
    return getRegularStyle(
      color: color,
      fontSize: size,
    );
  }

  static TextStyle font14Grey700Regular(
      {double size = FontSize.s14, Color color = ColorsManager.grey700}) {
    return getRegularStyle(
      color: color,
      fontSize: size,
    );
  }

  static TextStyle font14Secondary600Regular(
      {double size = FontSize.s14, Color color = ColorsManager.secondary600}) {
    return getRegularStyle(
      color: color,
      fontSize: size,
    );
  }

  static TextStyle font12PrimaryRegular(
      {double size = FontSize.s12, Color color = ColorsManager.primaryColor}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font12Grey500Regular(
      {double size = FontSize.s12, Color color = ColorsManager.grey500}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font12Grey400Regular(
      {double size = FontSize.s12, Color color = ColorsManager.grey400}) {
    return getRegularStyle(color: color, fontSize: size);
  }

  static TextStyle font12Grey500RegularRoboto(
      {double size = FontSize.s12, Color color = ColorsManager.grey500}) {
    return getRegularStyle(
        color: color,
        fontSize: size,
        fontFamily: FontConstants.robotoFontFamily);
  }

  static TextStyle font10Grey300RegularRoboto(
      {double size = FontSize.s10, Color color = ColorsManager.grey300}) {
    return getRegularStyle(
        color: color,
        fontSize: size,
        fontFamily: FontConstants.robotoFontFamily);
  }

  static TextStyle font14Grey700RegularRoboto(
      {double size = FontSize.s14, Color color = ColorsManager.grey700}) {
    return getRegularStyle(
        color: color,
        fontSize: size,
        fontFamily: FontConstants.robotoFontFamily);
  }

  static TextStyle font9Grey400RegularRoboto(
      {double size = FontSize.s9, Color color = ColorsManager.grey400}) {
    return getRegularStyle(
        color: color,
        fontSize: size,
        fontFamily: FontConstants.robotoFontFamily);
  }

  static TextStyle font9Grey400Regular(
      {double size = FontSize.s9, Color color = ColorsManager.grey400}) {
    return getRegularStyle(color: color, fontSize: size);
  }

//light
  static TextStyle font12BlackLight(
      {double size = FontSize.s12, Color color = ColorsManager.black}) {
    return getLightStyle(color: color, fontSize: size);
  }

  static TextStyle font14Grey500Light(
      {double size = FontSize.s14, Color color = ColorsManager.grey500}) {
    return getLightStyle(color: color, fontSize: size);
  }

  static TextStyle font9Grey700Light(
      {double size = FontSize.s9, Color color = ColorsManager.grey700}) {
    return getLightStyle(color: color, fontSize: size);
  }
}
