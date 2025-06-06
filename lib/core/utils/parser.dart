import 'package:parki_dog/core/utils/values_manager.dart';

class Parser {
  ///parse dynamic value to double
  /// Returns:
  /// - `0.0` if the value is `null`
  /// - The double equivalent if the value is an `int`
  /// - The parsed double if the value is a non-empty, valid double `String`
  /// - `0.0` if the value is an invalid `String`
  /// - `0.0` for all other types
  static double parseToDouble(dynamic value) {
    if (value == null) {
      return AppDouble.d0;
    } else if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is String) {
      try {
        return value.isNotEmpty ? double.parse(value) : AppDouble.d0;
      } on FormatException {
        return AppDouble.d0;
      }
    } else {
      return AppDouble.d0;
    }
  }

  ///parse dynamic value to int
  /// Returns:
  /// - `0` if the value is `null`
  /// - The integer equivalent if the value is an `double`
  /// - The parsed int if the value is a non-empty, valid int `String`
  /// - `0` if the value is an invalid `String`
  /// - `0` for all other types
  static int parseToInt(dynamic value) {
    if (value == null) {
      return AppInt.i0;
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else if (value is String) {
      try {
        return int.parse(value);
      } on FormatException {
        try {
          return (value.isNotEmpty ? double.parse(value) : AppDouble.d0)
              .toInt();
        } on FormatException {
          return AppInt.i0;
        }
      }
    } else {
      return AppInt.i0;
    }
  }

  ///parse dynamic value to bool
  /// Returns:
  /// - `true`: for:  int 1, double 1 or String "1"
  /// - `false`: for all other types and cases
  static bool parseToBool(dynamic value) {
    if (value is double || value is int) {
      return value == 1;
    } else if (value is String) {
      return value == "1";
    } else if (value is bool) {
      return value;
    } else {
      return false;
    }
  }

  ///parse dynamic value to enum
  /// Returns:
  /// - The enum equivalent if the value is a valid `String`
  /// - `null` for all other types and cases
  static T? enumFromString<T>(Iterable<T> values, String value) {
    for (var element in values) {
      if (element.toString() == value) {
        return element;
      }
    }
    return null;
  }
}
