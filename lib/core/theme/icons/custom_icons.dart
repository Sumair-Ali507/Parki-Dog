import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:parki_dog/core/theme/app_colors.dart';

class CustomIcons {
  static const Widget email = ImageIcon(AssetImage('assets/icons/email.png'));
  static const Widget key = ImageIcon(AssetImage('assets/icons/key.png'));
  static Widget google = Image.asset('assets/icons/google.png');
  static Widget facebook = SvgPicture.asset('assets/icons/facebook_logo.svg');
  static Widget apple = SvgPicture.asset('assets/icons/apple-round.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget camera = Image.asset('assets/icons/camera-plus.png');
  static Widget calendar = Image.asset('assets/icons/calendar.png');
  static const Widget male = ImageIcon(AssetImage('assets/icons/male.png'));
  static const Widget female = ImageIcon(AssetImage('assets/icons/female.png'));
  static Widget notification = Image.asset('assets/icons/bell.png');
  static Widget newNotification = SvgPicture.asset('assets/icons/bell-solid.svg', width: 24, height: 24);
  static Widget message = SvgPicture.asset(
    'assets/icons/message-solid.svg',
    width: 24,
    height: 24,
    color: AppColors.primary,
  );

  static Widget bone = SvgPicture.asset('assets/icons/bone.svg', width: 16, height: 16, fit: BoxFit.cover);
  static Widget boneFilled = SvgPicture.asset('assets/icons/bone-filled.svg', width: 16, height: 16, fit: BoxFit.cover);
  static Widget mapPin = SvgPicture.asset('assets/icons/map-pin.svg', width: 16, height: 16, fit: BoxFit.cover);
  static Widget clock = Image.asset('assets/icons/clock.png');
  static Widget terms = const Icon(
    Icons.my_library_books_outlined,
    color: AppColors.primary,
  );
  static Widget bulldogSmall = Image.asset(
    'assets/icons/bulldog.png',
    width: 16,
    height: 16,
    fit: BoxFit.cover,
  );
  static Widget bulldogLarge = Image.asset(
    'assets/icons/bulldog.png',
    width: 24,
    height: 24,
    fit: BoxFit.cover,
  );
  static Widget bellRinging = Image.asset('assets/icons/bell-ringing.png');

  static Widget home = Image.asset('assets/icons/home.png', width: 24, height: 24, fit: BoxFit.cover);
  static Widget homeInactive = Image.asset('assets/icons/home-inactive.png', width: 24, height: 24, fit: BoxFit.cover);
  static Widget location = Image.asset('assets/icons/location.png', width: 24, height: 24, fit: BoxFit.cover);
  static Widget locationInactive =
      Image.asset('assets/icons/location-inactive.png', width: 24, height: 24, fit: BoxFit.cover);

  static Widget paw = SvgPicture.asset('assets/icons/paw.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget profile = SvgPicture.asset('assets/icons/user-circle.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget bulldogSvg = SvgPicture.asset('assets/icons/bulldog.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget bulldogYellow = SvgPicture.asset('assets/icons/bulldog.svg',
      colorFilter: const ColorFilter.mode(AppColors.secondary, BlendMode.srcIn),
      width: 24,
      height: 24,
      fit: BoxFit.cover);
  static Widget bulldogRed = SvgPicture.asset('assets/icons/bulldog.svg',
      colorFilter: const ColorFilter.mode(Color(0xffC70404), BlendMode.srcIn),
      width: 24,
      height: 24,
      fit: BoxFit.cover);
  static Widget bulldogGreen = SvgPicture.asset('assets/icons/bulldog.svg',
      colorFilter: const ColorFilter.mode(Color(0xff06851A), BlendMode.srcIn),
      width: 24,
      height: 24,
      fit: BoxFit.cover);
  static Widget bulldogCheck =
      SvgPicture.asset('assets/icons/bulldog-check.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget settings = SvgPicture.asset('assets/icons/settings.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget logout = SvgPicture.asset('assets/icons/log-out.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget gender = SvgPicture.asset('assets/icons/man.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget calendarHeart = SvgPicture.asset('assets/icons/calendar.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget weight = SvgPicture.asset('assets/icons/scales.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget edit = SvgPicture.asset('assets/icons/edit.svg', width: 16, height: 16, fit: BoxFit.cover);
  static Widget user = SvgPicture.asset('assets/icons/user.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget phone = SvgPicture.asset('assets/icons/phone-01.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget userPin = SvgPicture.asset('assets/icons/marker-pin-04.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget cart = SvgPicture.asset('assets/icons/shopping-cart.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget cartActive =
      SvgPicture.asset('assets/icons/shopping-cart-active.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget safe = SvgPicture.asset('assets/icons/shield-tick.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget unsafe = SvgPicture.asset('assets/icons/shield-cross.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget bulldogAdd = SvgPicture.asset('assets/icons/bulldog-add.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget hand = SvgPicture.asset('assets/icons/hand.svg', width: 24, height: 24, fit: BoxFit.cover);
  static Widget checkHeart = SvgPicture.asset('assets/icons/check-heart.svg', width: 24, height: 24, fit: BoxFit.cover);
}
