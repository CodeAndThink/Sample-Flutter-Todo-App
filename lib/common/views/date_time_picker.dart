import 'package:flutter/material.dart';

//Date Picker Function
Future<DateTime?> selectDate(BuildContext context) async {
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(1900);
  DateTime lastDate = DateTime(2101);

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  return picked;
}

//Time Picker Function
Future<TimeOfDay?> selectTime(BuildContext context) async {
  TimeOfDay initialTime = TimeOfDay.now();

  final TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: initialTime,
  );

  return picked;
}
