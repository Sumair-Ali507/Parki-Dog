import 'package:parki_dog/core/utils/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LocalizationHelper {
  /// get the text direction either LTR or RTL
  // static TextDirection getDirection(BuildContext context) =>
  //     context.deviceLocale.languageCode == StringsManager.en
  //         ? TextDirection.LTR
  //         : TextDirection.RTL;

  ///change language
  static Future<void> changeLanguage(BuildContext context) async =>
      await context.setLocale(Locale(
          context.locale.languageCode == StringsManager.en
              ? StringsManager.it
              : StringsManager.en));

  ///change to Arabic
  static Future<void> changeToItaliano(BuildContext context) async =>
      await context.setLocale(const Locale(StringsManager.it));

  ///change to english
  static Future<void> changeToEnglish(BuildContext context) async =>
      await context.setLocale(const Locale(StringsManager.en));

  /// get the text direction either LTR or RTL
  static String getLanguageCode(BuildContext context) =>
      context.deviceLocale.languageCode;
}
