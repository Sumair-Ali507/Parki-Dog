import 'package:flutter/cupertino.dart';

@immutable
abstract class LangState {}

class LangInitial extends LangState {}

class SetLangState extends LangState {}

class SetChangeLangState extends LangState {}
