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
  static String timeFormat(dynamic inputTime, BuildContext context) {
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
      if (currentLocale.languageCode == 'en') {
        return MaterialLocalizations.of(context)
            .formatTimeOfDay(time, alwaysUse24HourFormat: false);
      } else if (currentLocale.languageCode == 'vi') {
        return time.format(context);
      }
    }
    return time.format(context);
  }

  static DateTime? convertStringToDateTime(
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

  //Function converse custom String date to ISO 8601 String date
  static String convertDateToDefaltFormat(
      BuildContext context, String inputDate) {
    DateTime date =
        convertStringToDateTime(context, inputDate) ?? DateTime.now();
    String formattedDate = DateFormat(Configs.mediumDefaltDate).format(date);

    return formattedDate;
  }
}
