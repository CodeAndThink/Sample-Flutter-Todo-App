import 'package:flutter/material.dart';

class ConverseTime {
  TimeOfDay parseTimeOfDay(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  String timeFormat(String inputTime, BuildContext context) {
    final time = parseTimeOfDay(inputTime);
    final result = time.format(context);
    return result;
  }
}