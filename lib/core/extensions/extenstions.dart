import 'package:parki_dog/core/utils/strings_manager.dart';
import 'package:parki_dog/core/utils/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

extension PixelAndDpConversionExtensions on BuildContext {
  /// convert dp to pixel
  double dpToPixel(double dp) {
    return dp * MediaQuery.of(this).devicePixelRatio;
  }

  /// convert pixel to dp
  double pixelToDp(double pixels) {
    return pixels / MediaQuery.of(this).devicePixelRatio;
  }
}

extension ContextExtensions on BuildContext {
  /// get screen height
  double get height => MediaQuery.sizeOf(this).height;

  /// get screen width
  double get width => MediaQuery.sizeOf(this).width;
}

extension NavigationExtesnions on BuildContext {
  /// push named route
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  /// push replacement named route
  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// push named and remove until
  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  /// pop
  void pop() => Navigator.of(this).pop();
}

extension LanguageExtensions on BuildContext {
  /// determines if language is arabic?
  bool get isItaliano =>
      EasyLocalization.of(this)!.locale.languageCode == StringsManager.it;

  /// determines if language is english
  bool get isEnglish =>
      EasyLocalization.of(this)!.locale.languageCode == StringsManager.en;

  String get getLanguageCode => EasyLocalization.of(this)!.locale.languageCode;
}

extension StringOrNullExtensions on String? {
  /// check if string is null or empty
  bool isNullOrEmpty() => this == null || this == StringsManager.emptyString;
}

extension StringExtensions on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  String get formattedDateForInboxItem {
    final dateTime = DateTime.parse(this).toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final inputDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (inputDate == today) {
      return DateFormat('hh:mm a').format(dateTime); // 06:33 PM
    } else if (inputDate == yesterday) {
      return "Yesterday";
    } else if (dateTime.year == now.year) {
      return DateFormat('MM-dd').format(dateTime); // 01-17
    } else {
      return DateFormat('MM-dd-yyyy').format(dateTime); // 01-17-2024
    }
  }
}

extension BoolExtensions on bool? {
  bool isNotNullOrTrue() => this != null || this == true;
  bool isNotNullAndTrue() => this != null && this == true;
}

extension ListExtensions<T> on List<T>? {
  /// check if list is null or empty
  bool isNullOrEmpty() => this == null || this!.isEmpty;
}

extension RemoveDuplicates on List {
  List get removeDuplicates {
    return [
      ...{...this}
    ];
  }
}

extension ParseToDoubleExtension on dynamic {
  double parseToDouble() {
    if (this == null) return AppDouble.d0;
    if (this is int) {
      return (this as int).toDouble();
    } else if (this is String) {
      return this.isNotEmpty
          ? double.tryParse(this) ?? AppDouble.d0
          : AppDouble.d0;
    } else if (this is double) {
      return this;
    } else {
      throw ArgumentError('Unsupported type: $runtimeType');
    }
  }
}
