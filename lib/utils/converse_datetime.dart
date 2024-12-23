import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/configs/configs.dart';

class ConverseDateTime {
  //Function converses time in string type to TimeOfDay type
  static TimeOfDay parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  //Function converses time to suitable locale
  static String timeFormat( BuildContext context, dynamic inputTime) {
    final TimeOfDay time;
    if (inputTime is String) {
      time = parseTimeOfDay(inputTime);
    } else {
      time = inputTime;
    }

    final Locale currentLocale = Localizations.localeOf(context);
    if (Platform.isAndroid) {
      return time.format(context);
    }
    if (Platform.isIOS) {
      if (currentLocale.languageCode == Configs.defaultLocale.languageCode) {
        return MaterialLocalizations.of(context)
            .formatTimeOfDay(time, alwaysUse24HourFormat: false);
      } else if (currentLocale.languageCode == Configs.viLocale.languageCode) {
        return time.format(context);
      }
    }
    return time.format(context);
  }

  //Convert String to DateTime type based on locale
  static DateTime? convertStringToDateTimeByLocale(
      BuildContext context, String inputDate) {
    final formats = [
      Configs.mediumDefaltDate,
      Configs.mediumEnDate,
      Configs.mediumVnDate,
    ];

    for (var format in formats) {
      try {
        DateTime date = DateFormat(format).parse(inputDate);
        return date;
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  //Convert DateTime to String type based on locale
  static String convertDateTimeToStringFormattedByLocale(
      BuildContext context, DateTime inputDate) {
    final Locale currentLocale = Localizations.localeOf(context);

    if (currentLocale == Configs.viLocale) {
      String date = DateFormat(Configs.mediumVnDate).format(inputDate);
      String time = timeFormat(context, TimeOfDay.fromDateTime(inputDate));
      return '$time $date';
    } else {
      String date = DateFormat(Configs.mediumEnDate).format(inputDate);
      String time = timeFormat(context, TimeOfDay.fromDateTime(inputDate));
      return '$time $date';
    }
  }

  //Convert String to DateTime type
  static DateTime convertStringToLongDateTimeType(String inputDate) {
    try {
      DateTime date = DateFormat(Configs.longDefaltDateTime).parse(inputDate);
      return date;
    } catch (e) {
      return DateTime.now();
    }
  }

  //Convert String to DateTime type
  static DateTime convertStringToMediumDateTimeType(String inputDate) {
    try {
      DateTime date = DateFormat(Configs.mediumDefaltDate).parse(inputDate);
      return date;
    } catch (e) {
      return DateTime.now();
    }
  }

  //Function converse custom String date to ISO 8601 String date
  static String convertDateToDefaltFormat(
      BuildContext context, String inputDate) {
    DateTime date =
        convertStringToDateTimeByLocale(context, inputDate) ?? DateTime.now();
    String formattedDate = DateFormat(Configs.mediumDefaltDate).format(date);

    return formattedDate;
  }
}
