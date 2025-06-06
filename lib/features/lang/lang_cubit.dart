import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:parki_dog/core/services/hive/hive.dart';
import 'lang_state.dart';

class LangCubit extends Cubit<LangState> {
  LangCubit() : super(LangInitial());

  String lang = '';
  setDataStorage() {
    if (lang != '') return;
    lang = HiveStorageService.readData(key: 'lang') ?? '';
  }

  changeLang(String lang, BuildContext context) async {
    HiveStorageService.writeData(key: 'lang', value: lang);
    this.lang = lang;
    await context.setLocale(Locale(lang));
    emit(SetLangState());
  }
}
