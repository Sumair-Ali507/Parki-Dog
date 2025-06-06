import 'package:parki_dog/core/utils/strings_manager.dart';
import 'package:flutter/material.dart';

enum LanguageType { english, italy }

const String italiano = StringsManager.it;
const String english = StringsManager.en;

const Locale italianoLocale = Locale(StringsManager.it);
const Locale englishLocale = Locale(StringsManager.en);

const String localizationPath = 'assets/translations';

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return english;
      case LanguageType.italy:
        return italiano;
    }
  }
}
