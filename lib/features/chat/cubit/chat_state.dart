import 'package:flutter/cupertino.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatDataHasBeenSet extends ChatState {}
