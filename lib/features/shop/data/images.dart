import 'package:flutter/material.dart';

class CustomIcons {
  static const String uchi = 'assets/images/Cute Dog.png';
  static const String teemmo = 'assets/images/teemo.jpg';
  static Widget teemo = Image.asset('assets/images/teemo.jpg');
  static Widget bone = Image.asset(
    'assets/icons/bone.png',
    width: 24,
    height: 24,
    fit: BoxFit.cover,
  );
  static Widget boneFilled = Image.asset(
    'assets/icons/bone-filled.png',
    width: 24,
    height: 24,
    fit: BoxFit.cover,
  );
}
