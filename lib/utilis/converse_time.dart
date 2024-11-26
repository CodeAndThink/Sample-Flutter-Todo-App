import 'dart:io';
import 'package:flutter/material.dart';

class ConverseTime {
  TimeOfDay parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  String timeFormat(dynamic inputTime, BuildContext context) {
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
}
