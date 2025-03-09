import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../utils/my_strings.dart';

class Converter {
  static double formatDouble(String value, {int precision = 2}) {
    return (double.tryParse(value) ?? 0.0).toPrecision(precision);
  }

  static String toCapitalized(String value) {
    return value.toLowerCase().capitalizeFirst ?? '';
  }

  static String roundDoubleAndRemoveTrailingZero(String value) {
    try {
      double number = double.parse(value);
      String b = number.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '');
      return b;
    } catch (e) {
      return value;
    }
  }

  static String formatNumber(String value, {int precision = 2}) {
    try {
      double number = double.parse(value);
      String b = number.toStringAsFixed(precision);
      return b;
    } catch (e) {
      return value;
    }
  }

  static String removeQuotationAndSpecialCharacterFromString(String value) {
    try {
      String formatedString =
          value.replaceAll('"', '').replaceAll('[', '').replaceAll(']', '');
      return formatedString;
    } catch (e) {
      return value;
    }
  }

  static String replaceUnderscoreWithSpace(String value) {
    try {
      String formatedString = value.replaceAll('_', ' ');
      String v =
          formatedString.split(" ").map((str) => str.capitalize).join(" ");
      return v;
    } catch (e) {
      return value;
    }
  }

  static String getFormatedDateWithStatus(String inputValue) {
    String value = inputValue;
    try {
      var list = inputValue.split(' ');
      var dateSection = list[0].split('-');
      var timeSection = list[1].split(':');
      int year = int.parse(dateSection[0]);
      int month = int.parse(dateSection[1]);
      int day = int.parse(dateSection[2]);
      int hour = int.parse(timeSection[0]);
      int minute = int.parse(timeSection[1]);
      int second = int.parse(timeSection[2]);
      final startTime = DateTime(year, month, day, hour, minute, second);
      final currentTime = DateTime.now();

      int dayDef = currentTime.difference(startTime).inDays;
      int hourDef = currentTime.difference(startTime).inHours;
      final minDef = currentTime.difference(startTime).inMinutes;
      final secondDef = currentTime.difference(startTime).inSeconds;

      if (dayDef == 0) {
        if (hourDef <= 0) {
          if (minDef <= 0) {
            value = '$secondDef ${MyStrings.secondAgo}'.tr;
          } else {
            value = '$hourDef ${MyStrings.minutesAgo}'.tr;
          }
        } else {
          value = '$hourDef ${MyStrings.hourAgo}'.tr;
        }
      } else {
        value = '$dayDef ${MyStrings.daysAgo}'.tr;
      }
    } catch (e) {
      value = inputValue;
    }

    return value;
  }

  static String getTrailingExtension(int number) {
    List<String> list = [
      'th',
      'st',
      'nd',
      'rd',
      'th',
      'th',
      'th',
      'th',
      'th',
      'th'
    ];
    if (((number % 100) >= 11) && ((number % 100) <= 13)) {
      return '${number}th';
    } else {
      int value = (number % 10).toInt();
      return '$number${list[value]}';
    }
  }

  static String addLeadingZero(String value) {
    return value.padLeft(2, '0');
  }

  static String sum(String first, String last, {int precision = 2}) {
    double firstNum = double.tryParse(first) ?? 0;
    double secondNum = double.tryParse(last) ?? 0;
    double result = firstNum + secondNum;
    return formatNumber(result.toString(), precision: precision);
  }

  static String calculateDiscount(String price, String discount,
      {int precision = 2, bool isPercentageCalculation = false}) {
    double p = formatDouble(price);
    double d = formatDouble(discount);
    double result = 0;
    if (isPercentageCalculation) {
      result = p - ((p * d) / 100);
      printX("calculateDiscount $result");
    } else {
      result = p - d;
    }
    return formatDouble(result.toString()).toString();
  }

  static String showPercent(String curSymbol, String s) {
    double value = 0;
    value = double.tryParse(s) ?? 0;
    if (value > 0) {
      return ' + $curSymbol$value';
    } else {
      return '';
    }
  }

  static mul(String first, String second) {
    double result =
        (double.tryParse(first) ?? 0) * (double.tryParse(second) ?? 0);
    return Converter.formatNumber(result.toString());
  }

  static calculateRate(String amount, String rate, {int precision = 2}) {
    double result =
        (double.tryParse(amount) ?? 0) / (double.tryParse(rate) ?? 0);
    return Converter.formatNumber(result.toString(), precision: precision);
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

//Custom
extension StringExtension on String {
  ///replace key value
  ///from string and get full data
  ///
  /// example: PRODUCT NAME ${product.name} and Price ${product.price}
  String rKv(Map<String, String> replacements) {
    String result = this;
    replacements.forEach((key, value) {
      result = result.replaceAll("{$key}", value);
    });
    return result;
  }

  String removeNull() {
    String text = this;
    String result = text.contains('null') ? text.replaceAll('null', '') : text;
    return result;
  }
  //
}

void printX(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

void loggerX(Object? object) {
  final log = Logger();
  log.d(object);
}

void loggerI(Object? object) {
  final log = Logger();
  log.i(object);
}
