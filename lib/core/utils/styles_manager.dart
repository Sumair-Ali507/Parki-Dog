import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parki_dog/core/utils/font_manager.dart';

TextStyle _getTextStyle(FontWeight fontWeight, double fontSize, Color color,
    {String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return TextStyle(
      fontSize: fontSize.sp,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
      decorationColor: color);
}

/// extra light Style
TextStyle getThinStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.thin, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// extra light Style
TextStyle getExtraLightStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.extraLight, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// Light Style
TextStyle getLightStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.light, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// Regular Style
TextStyle getRegularStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.regular, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// medium Style
TextStyle getMediumStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.medium, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// SimiBold Style
TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.semiBold, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// Bold Style
TextStyle getBoldStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.bold, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// ExtraBold Style
TextStyle getExtraBoldStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.extraBold, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}

/// Black Style
TextStyle getBlackStyle(
    {double fontSize = FontSize.s12,
    required Color color,
    String fontFamily = FontConstants.poppinsFontFamily,
    TextDecoration decoration = TextDecoration.none}) {
  return _getTextStyle(FontWeightManager.black, fontSize, color,
      fontFamily: fontFamily, decoration: decoration);
}
